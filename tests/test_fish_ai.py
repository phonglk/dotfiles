"""Exercise the Fish AI command picker with private homes and mocked providers."""
import io
import json
import os
from pathlib import Path
import pty
import re
import select
import shutil
import struct
import subprocess
import sys
import tempfile
import termios
import time
import types
import unittest
import unicodedata
import fcntl
from unittest import mock


REPO = Path(__file__).resolve().parents[1]
BACKEND = REPO / "fish/.config/fish/ai_commands.py"
FISH_FUNCTION = REPO / "fish/.config/fish/functions/fish_ai.fish"
FISH = shutil.which("fish")
ANSI = re.compile(r"\x1b\[[0-?]*[ -/]*[@-~]")


class IndicatorStream(io.StringIO):
    def __init__(self, tty):
        super().__init__()
        self.tty = tty

    def isatty(self):
        return self.tty


class FishAiBackendTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="dotfiles-ai-test-")
        self.addCleanup(self.tmp.cleanup)
        self.base = Path(self.tmp.name)
        self.home = self.base / "home"
        self.bin = self.base / "bin"
        self.cwd = self.base / "working folder"
        self.session = self.base / "session"
        self.log = self.base / "calls.jsonl"
        for path in [self.home, self.bin, self.cwd, self.session]:
            path.mkdir(mode=0o700)
        self.env = dict(os.environ, HOME=str(self.home),
                        XDG_CONFIG_HOME=str(self.home / ".config"),
                        PATH=str(self.bin) + os.pathsep + os.environ.get("PATH", ""),
                        MOCK_AI_LOG=str(self.log), MOCK_FZF_ACTION="enter",
                        MOCK_FZF_INDEX="0", TERM="xterm-256color")
        for name in ["CODEX_API_KEY", "OPENAI_API_KEY", "CODEX_ACCESS_TOKEN", "CODEX_HOME",
                     "FZF_DEFAULT_OPTS", "FZF_DEFAULT_COMMAND"]:
            self.env.pop(name, None)
        self.suggestions = [
            {"label": "Matching lines", "command": "rg -n 'TODO' .",
             "explanation": "Find matching lines recursively."},
            {"label": "Filenames only", "command": "rg -l 'TODO' .",
             "explanation": "List matching file paths."},
            {"label": "Include hidden files", "command": "rg --hidden -n 'TODO' .",
             "explanation": "Include hidden files."},
        ]
        self.response(self.suggestions)
        self.executable("codex", r'''
import json, os, sys
from pathlib import Path
args = sys.argv[1:]
prompt = sys.stdin.read()
with open(os.environ["MOCK_AI_LOG"], "a") as log:
    log.write(json.dumps({"tool": "codex", "args": args, "input": prompt,
                          "cwd": os.getcwd()}) + "\n")
if os.environ.get("MOCK_CODEX_EXIT"):
    sys.stderr.write(os.environ.get("MOCK_CODEX_STDERR", "mock model failure"))
    sys.exit(int(os.environ["MOCK_CODEX_EXIT"]))
output_flag = "--output-last-message" if "--output-last-message" in args else "-o"
Path(args[args.index(output_flag) + 1]).write_text(os.environ["MOCK_CODEX_RESPONSE"])
''')
        self.executable("fzf", r'''
import json, os, sys
args = sys.argv[1:]
rows = sys.stdin.read().splitlines()
prior_calls = 0
try:
    with open(os.environ["MOCK_AI_LOG"]) as log:
        prior_calls = sum(json.loads(line)["tool"] == "fzf" for line in log)
except FileNotFoundError:
    pass
with open(os.environ["MOCK_AI_LOG"], "a") as log:
    log.write(json.dumps({"tool": "fzf", "args": args, "rows": rows}) + "\n")
actions = os.environ.get("MOCK_FZF_ACTIONS", os.environ.get("MOCK_FZF_ACTION", "enter")).split(",")
action = actions[min(prior_calls, len(actions) - 1)]
if action == "cancel":
    sys.exit(130)
if action == "escape":
    print("esc")
    sys.exit(0)
if action == "bad-id":
    print("\n999999\tforged selection")
    sys.exit(0)
indices = os.environ.get("MOCK_FZF_INDICES", os.environ.get("MOCK_FZF_INDEX", "0")).split(",")
index = int(indices[min(prior_calls, len(indices) - 1)])
if not rows:
    sys.exit(1)
if any(arg.startswith("--expect") for arg in args):
    print("ctrl-o" if action == "refine" else "")
print(rows[index])
''')

    def executable(self, name, source):
        path = self.bin / name
        path.write_text("#!" + sys.executable + "\n" + source.lstrip())
        path.chmod(0o755)

    def response(self, suggestions):
        self.env["MOCK_CODEX_RESPONSE"] = json.dumps({"suggestions": suggestions})

    def query(self, prompt="search for TODO here", cached=False, new=False):
        args = [sys.executable, str(BACKEND), "query", "--session", str(self.session),
                "--cwd", str(self.cwd)]
        if cached:
            args.append("--cached")
        if new:
            args.append("--new")
        return subprocess.run(args, input=prompt, env=self.env, text=True,
                              capture_output=True, timeout=15)

    def calls(self, tool=None):
        records = [json.loads(line) for line in self.log.read_text().splitlines()] if self.log.exists() else []
        return [record for record in records if tool is None or record["tool"] == tool]

    def fields(self, result):
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(result.stdout.endswith("\0"), repr(result.stdout))
        return result.stdout[:-1].split("\0")

    def backend_module(self):
        module = types.ModuleType("fish_ai_test_backend")
        module.__file__ = str(BACKEND)
        exec(compile(BACKEND.read_text(), str(BACKEND), "exec"), module.__dict__)
        return module

    def fzf_option(self, args, option):
        for index, argument in enumerate(args):
            if argument == option:
                return args[index + 1]
            if argument.startswith(option + "="):
                return argument.partition("=")[2]
        self.fail("Missing fzf option: " + option)

    def start_fish(self):
        config = self.home / ".config/fish"
        config.mkdir(parents=True)
        shutil.copy2(BACKEND, config / "ai_commands.py")
        master, slave = pty.openpty()
        fcntl.ioctl(slave, termios.TIOCSWINSZ, struct.pack("HHHH", 40, 180, 0, 0))
        init = "\n".join([
            "source '" + str(FISH_FUNCTION) + "'",
            "fish_default_key_bindings",
            "fish_ai --install-bindings",
            "function fish_prompt; printf 'FISH_READY> '; end",
            "function fish_greeting; end",
            "function __report_ai_test_buffer",
            "printf '\\nAI_TEST_BUFFER:[%s]\\nAI_TEST_CURSOR:[%s]\\n' (commandline --current-buffer) (commandline --cursor)",
            "commandline -f repaint",
            "end",
            "bind ctrl-t __report_ai_test_buffer",
        ])
        def setup_controlling_terminal():
            os.setsid()
            fcntl.ioctl(slave, termios.TIOCSCTTY, 0)

        self.tty = subprocess.Popen([FISH, "--no-config", "--interactive", "--init-command", init],
                                    stdin=slave, stdout=slave, stderr=slave,
                                    env=dict(self.env, TERM="dumb"), preexec_fn=setup_controlling_terminal)
        os.close(slave)
        self.master = master
        self.tty_output = b""

        def cleanup():
            os.close(master)
            self.tty.terminate()
            try:
                self.tty.wait(timeout=2)
            except subprocess.TimeoutExpired:
                self.tty.kill()
                self.tty.wait(timeout=2)

        self.addCleanup(cleanup)
        self.wait_for(b"FISH_READY> ")

    def send(self, data):
        offset = len(self.tty_output)
        os.write(self.master, data)
        return offset

    def wait_for(self, needle, offset=0, timeout=10):
        deadline = time.monotonic() + timeout
        while needle not in self.tty_output[offset:]:
            if time.monotonic() >= deadline:
                self.fail("Timed out waiting for " + repr(needle) + ": " + repr(self.tty_output[-4000:]))
            readable, _, _ = select.select([self.master], [], [], 0.1)
            if readable:
                try:
                    data = os.read(self.master, 65536)
                except OSError:
                    data = b""
                if not data:
                    self.fail("Fish exited before " + repr(needle) + ": " + repr(self.tty_output[-4000:]))
                self.tty_output += data

    def report_buffer(self, expected, cursor=None):
        offset = self.send(b"\x14")
        self.wait_for(("AI_TEST_BUFFER:[" + expected + "]").encode(), offset)
        if cursor is not None:
            self.wait_for(("AI_TEST_CURSOR:[" + str(cursor) + "]").encode(), offset)

    def test_generates_commands_using_existing_cli_auth_without_executing_them(self):
        marker = self.base / "must-not-run"
        command = "printf unsafe > " + str(marker)
        self.suggestions[0]["command"] = command
        self.response(self.suggestions)
        result = self.query()
        self.assertEqual(self.fields(result), ["insert", command])
        self.assertFalse(marker.exists())
        call = self.calls("codex")[0]
        args = call["args"]
        self.assertIn("exec", args)
        self.assertIn("--ignore-user-config", args)
        self.assertIn("--ephemeral", args)
        self.assertIn("--skip-git-repo-check", args)
        self.assertIn("--output-schema", args)
        self.assertIn("read-only", args)
        self.assertNotIn("danger-full-access", args)
        self.assertNotIn("search for TODO here", args)
        self.assertIn("search for TODO here", call["input"])
        self.assertIn(str(self.cwd), call["input"])
        self.assertNotEqual(Path(call["cwd"]), self.cwd)

    def test_loading_status_uses_plain_stderr_without_changing_the_reply(self):
        result = self.query()
        self.assertEqual(self.fields(result), ["insert", self.suggestions[0]["command"]])
        self.assertRegex(result.stderr.casefold(), r"generat")
        self.assertIn("ctrl", result.stderr.casefold())
        self.assertNotIn("\r", result.stderr)
        self.assertNotIn("\x1b", result.stderr)

    def test_loading_status_distinguishes_refining_an_option(self):
        self.env["MOCK_FZF_ACTION"] = "refine"
        self.assertEqual(self.fields(self.query())[0], "refine")
        self.env["MOCK_FZF_ACTION"] = "enter"
        result = self.query("only TypeScript files")
        self.assertEqual(self.fields(result), ["insert", self.suggestions[0]["command"]])
        self.assertRegex(result.stderr.casefold(), r"refin")
        self.assertNotIn("\r", result.stderr)
        self.assertNotIn("\x1b", result.stderr)

    def test_loading_indicator_animates_elapsed_time_and_clears_its_line(self):
        backend = self.backend_module()
        stream = IndicatorStream(tty=True)
        now = [10.0]
        indicator = backend.LoadingIndicator(stream=stream, env={"TERM": "xterm-256color"},
                                             clock=lambda: now[0])
        with indicator:
            initial = stream.getvalue()
            self.assertTrue(indicator.active)
            self.assertTrue(indicator.animated)
            self.assertRegex(initial.casefold(), r"generat")
            self.assertIn("ctrl", initial.casefold())
            now[0] += 0.3
            indicator.tick()
            self.assertGreater(len(stream.getvalue()), len(initial))
            now[0] += 2
            indicator.tick()
            self.assertRegex(ANSI.sub("", stream.getvalue()), r"2s")
        self.assertFalse(indicator.active)
        self.assertEqual(ANSI.sub("", stream.getvalue()).rsplit("\r", 1)[-1].strip(), "")
        closed = stream.getvalue()
        indicator.close()
        indicator.tick()
        self.assertEqual(stream.getvalue(), closed)
        self.assertNotIn("\x1b[?25", stream.getvalue(), "Spinner must not hide the terminal cursor")

    def test_loading_indicator_stays_static_for_redirected_and_dumb_output(self):
        backend = self.backend_module()
        for tty, environment in [(False, {"TERM": "xterm-256color"}), (True, {"TERM": "dumb"})]:
            with self.subTest(tty=tty, environment=environment):
                stream = IndicatorStream(tty)
                now = [0.0]
                with backend.LoadingIndicator(stream=stream, env=environment,
                                              clock=lambda: now[0]) as indicator:
                    initial = stream.getvalue()
                    self.assertFalse(indicator.animated)
                    now[0] = 5.0
                    indicator.tick()
                    self.assertEqual(stream.getvalue(), initial)
                self.assertEqual(stream.getvalue(), initial)
                self.assertEqual(initial.count("\n"), 1)
                self.assertNotIn("\r", initial)
                self.assertNotIn("\x1b", initial)

    def test_loading_indicator_supports_monochrome_animation_and_refinement(self):
        backend = self.backend_module()
        stream = IndicatorStream(tty=True)
        now = [0.0]
        with backend.LoadingIndicator(refining=True, stream=stream,
                                      env={"TERM": "xterm-256color", "NO_COLOR": "1"},
                                      clock=lambda: now[0]) as indicator:
            now[0] = 1.0
            indicator.tick()
        self.assertRegex(stream.getvalue().casefold(), r"refin")
        self.assertIn("\r", stream.getvalue())
        self.assertNotRegex(stream.getvalue(), r"\x1b\[[0-9;]*m")

    def exercise_generation(self, communicate_results, timeout=1.0):
        """Run the actual generation wrapper with a fake child process and terminal."""
        backend = self.backend_module()
        process = mock.Mock()
        process.returncode = None
        process.poll.side_effect = lambda: process.returncode
        outcomes = None if isinstance(communicate_results, BaseException) else iter(communicate_results)

        def communicate(*args, **kwargs):
            result = communicate_results if outcomes is None else next(outcomes)
            if isinstance(result, BaseException):
                raise result
            process.returncode = 0
            return result

        process.communicate.side_effect = communicate
        stream = IndicatorStream(tty=True)
        indicators = []
        indicator_class = backend.LoadingIndicator
        real_popen = backend.subprocess.Popen

        def loading(*args, **kwargs):
            kwargs.update(stream=stream, env={"TERM": "xterm-256color"})
            indicator = indicator_class(*args, **kwargs)
            indicators.append(indicator)
            return indicator

        def launch(arguments, **kwargs):
            if "--output-last-message" not in arguments:
                return real_popen(arguments, **kwargs)
            output = Path(arguments[arguments.index("--output-last-message") + 1])
            output.write_text(json.dumps({"suggestions": self.suggestions}))
            return process

        patches = [
            mock.patch.object(backend, "find_codex", return_value="/mock/codex"),
            mock.patch.object(backend, "LoadingIndicator", side_effect=loading),
            mock.patch.object(backend.subprocess, "Popen", side_effect=launch),
            mock.patch.object(backend, "_stop_process"),
            mock.patch.object(backend, "_timeout", return_value=timeout),
        ]
        return backend, process, stream, indicators, patches

    def test_loading_polls_codex_without_resending_the_prompt(self):
        backend, process, stream, indicators, patches = self.exercise_generation(
            [subprocess.TimeoutExpired("codex", 0.12), (None, None)])
        with patches[0], patches[1], patches[2], patches[3] as stop, patches[4]:
            result = backend.generate_suggestions(self.session, self.cwd, {}, "find TODO")
        self.assertEqual(result[0]["command"], self.suggestions[0]["command"])
        self.assertEqual(process.communicate.call_count, 2)
        first, second = process.communicate.call_args_list
        first_input = first.kwargs.get("input", first.args[0] if first.args else None)
        second_input = second.kwargs.get("input", second.args[0] if second.args else None)
        self.assertIn(b"find TODO", first_input)
        self.assertIsNone(second_input)
        stop.assert_not_called()
        self.assertTrue(indicators)
        self.assertTrue(all(not indicator.active for indicator in indicators))
        self.assertEqual(ANSI.sub("", stream.getvalue()).rsplit("\r", 1)[-1].strip(), "")

    def test_loading_cleanup_runs_for_timeout_and_keyboard_interrupt(self):
        for failure, expected in [(subprocess.TimeoutExpired("codex", 0.12), "timeout"),
                                  (KeyboardInterrupt(), "interrupt")]:
            with self.subTest(failure=expected):
                backend, process, stream, indicators, patches = self.exercise_generation(
                    failure, timeout=0.01)
                with patches[0], patches[1], patches[2], patches[3] as stop, patches[4]:
                    if expected == "timeout":
                        with self.assertRaisesRegex(backend.AssistantError, "timed out"):
                            backend.generate_suggestions(self.session, self.cwd, {}, "find TODO")
                    else:
                        with self.assertRaises(KeyboardInterrupt):
                            backend.generate_suggestions(self.session, self.cwd, {}, "find TODO")
                stop.assert_called_once_with(process)
                self.assertTrue(indicators)
                self.assertTrue(all(not indicator.active for indicator in indicators))
                self.assertEqual(ANSI.sub("", stream.getvalue()).rsplit("\r", 1)[-1].strip(), "")

    def test_refines_the_selected_command_with_original_request_context(self):
        self.env.update(MOCK_FZF_ACTION="refine", MOCK_FZF_INDEX="1")
        result = self.query("search for TODO here")
        self.assertEqual(self.fields(result), ["refine", "Filenames only", "rg -l 'TODO' .",
                                                "List matching file paths."])
        self.suggestions[0]["command"] = "rg -l -g '*.ts' 'TODO' ."
        self.response(self.suggestions)
        self.env.update(MOCK_FZF_ACTION="enter", MOCK_FZF_INDEX="0")
        result = self.query("only TypeScript files")
        self.assertEqual(self.fields(result), ["insert", "rg -l -g '*.ts' 'TODO' ."])
        call = self.calls("codex")[1]
        for context in ["search for TODO here", "only TypeScript files", "rg -l 'TODO' ."]:
            self.assertIn(context, call["input"])

    def test_escape_and_cached_reopen_preserve_candidates_without_model_call(self):
        self.env["MOCK_FZF_ACTION"] = "escape"
        self.assertEqual(self.fields(self.query()), ["back"])
        self.env.update(MOCK_FZF_ACTION="enter", MOCK_FZF_INDEX="1")
        result = self.query(cached=True)
        self.assertEqual(self.fields(result), ["insert", "rg -l 'TODO' ."])
        self.assertEqual(len(self.calls("codex")), 1)

    def test_ctrl_c_from_picker_cancels_without_insert_record(self):
        self.env["MOCK_FZF_ACTION"] = "cancel"
        result = self.query()
        self.assertEqual(result.returncode, 130, result.stderr)
        self.assertEqual(result.stdout, "")

    def test_failed_new_request_preserves_previous_cached_choices(self):
        self.env["MOCK_FZF_ACTION"] = "escape"
        self.assertEqual(self.fields(self.query()), ["back"])
        state_file = self.session / "session.json"
        original_state = state_file.read_bytes()
        self.env["MOCK_CODEX_EXIT"] = "17"
        result = self.query("find README files", new=True)
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(state_file.read_bytes(), original_state)
        self.env.pop("MOCK_CODEX_EXIT")
        self.env["MOCK_FZF_ACTION"] = "enter"
        self.assertEqual(self.fields(self.query(cached=True)), ["insert", "rg -n 'TODO' ."])

    def test_new_request_does_not_inherit_the_previous_refinement_base(self):
        self.env.update(MOCK_FZF_ACTION="refine", MOCK_FZF_INDEX="1")
        self.assertEqual(self.fields(self.query())[0], "refine")
        self.env["MOCK_FZF_ACTION"] = "enter"
        self.assertEqual(self.query("find README files", new=True).returncode, 0)
        prompt = self.calls("codex")[1]["input"]
        self.assertIn("find README files", prompt)
        self.assertNotIn("search for TODO here", prompt)
        self.assertNotIn("rg -l 'TODO' .", prompt)

    def test_model_failure_does_not_open_picker_or_emit_insert_record(self):
        self.env.update(MOCK_CODEX_EXIT="17", MOCK_CODEX_STDERR="mock model failure")
        result = self.query()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")
        self.assertEqual(self.calls("fzf"), [])

    def test_provider_error_cannot_emit_terminal_escape_sequences(self):
        self.env.update(MOCK_CODEX_EXIT="17", MOCK_CODEX_STDERR="\x1b[2Jmock model failure")
        result = self.query()
        self.assertNotEqual(result.returncode, 0)
        self.assertNotIn("\x1b", result.stderr)

    def test_invalid_json_does_not_open_picker(self):
        self.env["MOCK_CODEX_RESPONSE"] = "not JSON"
        result = self.query()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")
        self.assertEqual(self.calls("fzf"), [])

    def test_invalid_schema_does_not_open_picker(self):
        self.env["MOCK_CODEX_RESPONSE"] = json.dumps({"suggestions": [{"command": "pwd"}]})
        result = self.query()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.calls("fzf"), [])

    def test_terminal_control_characters_in_commands_are_rejected(self):
        self.suggestions[0]["command"] = "printf harmless\x1b[2J"
        self.response(self.suggestions)
        result = self.query()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")
        self.assertEqual(self.calls("fzf"), [])

    @unittest.skipUnless(FISH, "Fish is unavailable")
    def test_invalid_fish_syntax_is_rejected(self):
        self.suggestions[0]["command"] = "echo 'unterminated"
        self.response(self.suggestions)
        result = self.query()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(self.calls("fzf"), [])

    def test_picker_cannot_forge_a_command_outside_generated_candidates(self):
        self.env["MOCK_FZF_ACTION"] = "bad-id"
        result = self.query()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")

    def test_session_files_are_private(self):
        self.assertEqual(self.query().returncode, 0)
        for path in self.session.rglob("*"):
            if path.is_file():
                self.assertEqual(path.stat().st_mode & 0o077, 0, str(path))

    def test_preview_displays_the_exact_command_without_running_it(self):
        marker = self.base / "preview-must-not-run"
        command = "touch " + str(marker)
        self.suggestions[0]["command"] = command
        self.response(self.suggestions)
        self.assertEqual(self.query().returncode, 0)
        result = subprocess.run([sys.executable, str(BACKEND), "preview", "--session",
                                 str(self.session), "--index", "0"], env=self.env,
                                text=True, capture_output=True, timeout=10)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(command, result.stdout)
        self.assertIn(self.suggestions[0]["explanation"], result.stdout)
        self.assertFalse(marker.exists())

    def test_generated_command_text_is_not_embedded_in_preview_shell_command(self):
        command = "printf '%s' '$(touch should-not-run); fish syntax'"
        self.suggestions[0]["command"] = command
        self.response(self.suggestions)
        self.assertEqual(self.fields(self.query()), ["insert", command])
        args = self.calls("fzf")[0]["args"]
        self.assertNotIn(command, " ".join(args))
        self.assertFalse((self.cwd / "should-not-run").exists())

    def test_picker_keeps_the_followup_action_visible_in_a_narrow_list(self):
        self.assertEqual(self.query().returncode, 0)
        args = self.calls("fzf")[0]["args"]
        header = next(arg.partition("=")[2] for arg in args if arg.startswith("--header="))
        self.assertGreater(len(header.splitlines()), 1)
        followup_line = next(line for line in header.splitlines()
                             if "ctrl+o" in line.casefold() and "follow" in line.casefold())
        self.assertLessEqual(len(followup_line), 40, followup_line)

    def test_picker_has_labelled_command_and_preview_panels_with_persistent_actions(self):
        self.assertEqual(self.query().returncode, 0)
        args = self.calls("fzf")[0]["args"]
        self.assertIn("command", self.fzf_option(args, "--list-label").casefold())
        self.assertIn("preview", self.fzf_option(args, "--preview-label").casefold())
        self.assertNotEqual(self.fzf_option(args, "--list-border"), "none")
        self.assertNotEqual(self.fzf_option(args, "--preview-border"), "none")
        footer = ANSI.sub("", self.fzf_option(args, "--footer"))
        for action in ["enter", "ctrl+o", "esc"]:
            self.assertIn(action, footer.casefold())
        followup_line = next(line for line in footer.splitlines()
                             if "ctrl+o" in line.casefold() and "follow" in line.casefold())
        self.assertLessEqual(len(followup_line), 40, followup_line)

    def test_colour_policy_respects_terminal_and_user_opt_outs(self):
        backend = self.backend_module()
        self.assertTrue(backend.color_enabled(env={"TERM": "xterm-256color"}, tty=True))
        self.assertTrue(backend.color_enabled(env={"TERM": "xterm-256color", "NO_COLOR": ""}, tty=True))
        for environment, tty in [
            ({"TERM": "xterm-256color", "NO_COLOR": "1"}, True),
            ({"TERM": "xterm-256color", "NO_COLOR": "0"}, True),
            ({"TERM": "dumb"}, True),
            ({"TERM": "xterm-256color"}, False),
        ]:
            with self.subTest(environment=environment, tty=tty):
                self.assertFalse(backend.color_enabled(env=environment, tty=tty))

    def test_syntax_colours_preserve_exact_command_text_without_executing_it(self):
        backend = self.backend_module()
        marker = self.base / "highlight-must-not-run"
        command = "printf  '%s\\n' 'two words'\n  touch " + str(marker)
        highlighted = backend.highlight_command(command, enabled=True)
        self.assertRegex(highlighted, r"\x1b\[[0-9;]*m")
        self.assertEqual(ANSI.sub("", highlighted), command)
        self.assertEqual(backend.highlight_command(command, enabled=False), command)
        self.assertFalse(marker.exists())

    def test_picker_stacks_preview_on_narrow_terminals_and_keeps_short_screen_controls(self):
        backend = self.backend_module()
        state = {"suggestions": self.suggestions, "selected": 0, "prompt": "find TODO"}
        for columns, rows, expected_direction in [(70, 30, "down"), (140, 35, "right")]:
            result = subprocess.CompletedProcess(["fzf"], 0, stdout="\n0\tMatching lines\n")
            with self.subTest(columns=columns, rows=rows), \
                    mock.patch.object(backend, "terminal_size", return_value=os.terminal_size((columns, rows))), \
                    mock.patch.object(backend, "color_enabled", return_value=False), \
                    mock.patch.object(backend.shutil, "which", return_value="/mock/fzf"), \
                    mock.patch.object(backend.subprocess, "run", return_value=result) as run:
                self.assertEqual(backend.choose_suggestion(self.session, state), ("insert", 0))
                args = run.call_args.args[0]
                self.assertTrue(self.fzf_option(args, "--preview-window").startswith(expected_direction))
                self.assertEqual(self.fzf_option(args, "--color"), "bw")
        with mock.patch.object(backend, "terminal_size", return_value=os.terminal_size((70, 16))), \
                mock.patch.object(backend, "color_enabled", return_value=False), \
                mock.patch.object(backend.shutil, "which", return_value="/mock/fzf"), \
                mock.patch.object(backend.subprocess, "run", return_value=result) as run:
            backend.choose_suggestion(self.session, state)
            args = run.call_args.args[0]
            self.assertIn("hidden", self.fzf_option(args, "--preview-window"))
            footer = ANSI.sub("", self.fzf_option(args, "--footer"))
            self.assertIn("ctrl", footer.casefold())
            self.assertIn("preview", footer.casefold())

    def test_preview_colour_modes_do_not_change_commands_or_override_no_color(self):
        marker = self.base / "colour-preview-must-not-run"
        command = "touch " + str(marker)
        self.suggestions[0]["command"] = command
        self.response(self.suggestions)
        self.assertEqual(self.query().returncode, 0)
        arguments = [sys.executable, str(BACKEND), "preview", "--session", str(self.session),
                     "--index", "0", "--color", "always"]
        environment = dict(self.env, TERM="xterm-256color")
        environment.pop("NO_COLOR", None)
        result = subprocess.run(arguments, env=environment, text=True, capture_output=True, timeout=10)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertRegex(result.stdout, r"\x1b\[[0-9;]*m")
        self.assertIn(command, ANSI.sub("", result.stdout))
        for overrides in [{"NO_COLOR": "1"}, {"TERM": "dumb"}]:
            with self.subTest(overrides=overrides):
                result = subprocess.run(arguments, env=dict(environment, **overrides), text=True,
                                        capture_output=True, timeout=10)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertNotRegex(result.stdout, r"\x1b\[[0-9;]*m")
                self.assertIn(command, result.stdout)
        result = subprocess.run(arguments[:-1] + ["auto"], env=environment, text=True,
                                capture_output=True, timeout=10)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotRegex(result.stdout, r"\x1b\[[0-9;]*m")
        self.assertFalse(marker.exists())

    def test_plain_panels_wrap_to_terminal_width_and_remove_terminal_controls(self):
        backend = self.backend_module()
        panel = backend.render_panel("Selected command", [
            "Only search TypeScript files in this folder.",
            "搜索文件 " * 8,
            "Untrusted\x1b[2Jtext",
        ], columns=32, enabled=False)
        self.assertIn("Selected command", panel)
        self.assertIn("TypeScript", panel)
        self.assertNotIn("\x1b", panel)
        for line in panel.splitlines():
            width = sum(0 if unicodedata.combining(char) else
                        2 if unicodedata.east_asian_width(char) in {"W", "F"} else 1
                        for char in line)
            self.assertLessEqual(width, 32, repr(line))

    def test_preview_prompts_for_a_followup_on_the_selected_command(self):
        self.assertEqual(self.query().returncode, 0)
        result = subprocess.run([sys.executable, str(BACKEND), "preview", "--session",
                                 str(self.session), "--index", "1"], env=self.env,
                                text=True, capture_output=True, timeout=10)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(self.suggestions[1]["command"], result.stdout)
        self.assertRegex(result.stdout.casefold(), r"follow[ -]up")
        self.assertIn("ctrl+o", result.stdout.casefold())

    def test_preview_shows_the_selected_options_own_followup_suggestions(self):
        first_followups = ["Show a count of matching lines.", "Show surrounding context.",
                           "Match TODO as literal text."]
        selected_followups = ["Limit this to TypeScript files.", "Include hidden files.",
                              "Ignore case when matching TODO."]
        self.suggestions[0]["follow_ups"] = first_followups
        self.suggestions[1]["follow_ups"] = selected_followups
        self.response(self.suggestions)
        self.env.update(MOCK_FZF_ACTION="refine", MOCK_FZF_INDEX="1")
        self.assertEqual(self.fields(self.query()),
                         ["refine", "Filenames only", "rg -l 'TODO' .",
                          "List matching file paths.", *selected_followups])
        result = subprocess.run([sys.executable, str(BACKEND), "preview", "--session",
                                 str(self.session), "--index", "1"], env=self.env,
                                text=True, capture_output=True, timeout=10)
        self.assertEqual(result.returncode, 0, result.stderr)
        for followup in selected_followups:
            self.assertIn(followup, result.stdout)
        for followup in first_followups:
            self.assertNotIn(followup, result.stdout)

    def test_invalid_followup_suggestions_do_not_open_the_picker(self):
        for value in ["not a list", ["one", "two", "three", "four"], [None]]:
            with self.subTest(value=value):
                self.suggestions[0]["follow_ups"] = value
                self.response(self.suggestions)
                result = self.query()
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")
        self.assertEqual(self.calls("fzf"), [])

    @unittest.skipUnless(FISH, "Fish is unavailable")
    def test_ctrl_o_prompt_selection_inserts_an_editable_command_without_running_it(self):
        marker = self.base / "pty-must-not-run"
        command = "printf executed > " + str(marker)
        self.suggestions[0]["command"] = command
        self.response(self.suggestions)
        self.start_fish()
        self.send(b"echo original draft")
        offset = self.send(b"\x0f")
        self.wait_for(b"PROMPT >", offset)
        offset = self.send(b"search for TODO\r")
        self.wait_for(command.encode(), offset)
        self.report_buffer(command)
        self.assertFalse(marker.exists())

    @unittest.skipUnless(FISH, "Fish is unavailable")
    def test_ctrl_c_restores_original_shell_buffer_and_cursor(self):
        self.start_fish()
        draft = "echo untouched"
        self.send(draft.encode() + b"\x02" * 4)
        offset = self.send(b"\x0f")
        self.wait_for(b"PROMPT >", offset)
        offset = self.send(b"\x03")
        self.wait_for(b"FISH_READY> ", offset)
        self.report_buffer(draft, len(draft) - 4)
        self.assertEqual(self.calls("codex"), [])

    @unittest.skipUnless(FISH, "Fish is unavailable")
    def test_refinement_mode_shows_selection_and_sends_followup_context(self):
        self.env.update(MOCK_FZF_ACTIONS="refine,enter", MOCK_FZF_INDICES="1,0")
        self.start_fish()
        self.send(b"\x0f")
        self.wait_for("AI · COMMAND ASSISTANT".encode())
        self.wait_for(b"PROMPT >")
        offset = self.send(b"search for TODO\r")
        self.wait_for(b"REFINE >", offset)
        self.wait_for(b"SELECTED COMMAND", offset)
        self.wait_for("AI · FOLLOW-UP".encode(), offset)
        self.wait_for(b"rg -l 'TODO' .", offset)
        offset = self.send(b"only TypeScript files\r")
        self.wait_for(b"FISH_READY> ", offset)
        self.wait_for(b"READY TO EDIT", offset)
        self.report_buffer("rg -n 'TODO' .")
        self.assertNotRegex(self.tty_output, rb"\x1b\[[0-9;]*m")
        self.assertEqual(len(self.calls("codex")), 2)
        self.assertIn("only TypeScript files", self.calls("codex")[1]["input"])
        self.assertIn("rg -l 'TODO' .", self.calls("codex")[1]["input"])

    @unittest.skipUnless(FISH, "Fish is unavailable")
    def test_repeated_followups_keep_the_latest_selection_and_prior_context(self):
        self.env.update(MOCK_FZF_ACTIONS="refine,refine,enter", MOCK_FZF_INDICES="1,2,0")
        self.start_fish()
        self.send(b"\x0f")
        self.wait_for(b"PROMPT >")
        offset = self.send(b"search for TODO\r")
        self.wait_for(b"REFINE >", offset)
        self.wait_for(b"rg -l 'TODO' .", offset)
        offset = self.send(b"only TypeScript files\r")
        self.wait_for(b"REFINE >", offset)
        self.wait_for(b"rg --hidden -n 'TODO' .", offset)
        offset = self.send(b"ignore case\r")
        self.wait_for(b"FISH_READY> ", offset)
        self.report_buffer("rg -n 'TODO' .")
        calls = self.calls("codex")
        self.assertEqual(len(calls), 3)
        for context in ["search for TODO", "only TypeScript files", "ignore case",
                        "rg --hidden -n 'TODO' ."]:
            self.assertIn(context, calls[2]["input"])

    @unittest.skipUnless(FISH, "Fish is unavailable")
    def test_numbered_followup_submits_its_text_for_the_selected_command(self):
        followups = ["Limit this to TypeScript files.", "Include hidden files.",
                     "Ignore case when matching TODO."]
        self.suggestions[1]["follow_ups"] = followups
        self.response(self.suggestions)
        self.env.update(MOCK_FZF_ACTIONS="refine,enter", MOCK_FZF_INDICES="1,0")
        self.start_fish()
        self.send(b"\x0f")
        self.wait_for(b"PROMPT >")
        offset = self.send(b"search for TODO\r")
        self.wait_for(b"REFINE >", offset)
        for index, followup in enumerate(followups, 1):
            self.wait_for(f"{index}. {followup}".encode(), offset)
        offset = self.send(b"2\r")
        self.wait_for(b"FISH_READY> ", offset)
        self.report_buffer("rg -n 'TODO' .")
        calls = self.calls("codex")
        self.assertEqual(len(calls), 2)
        context = json.loads(calls[1]["input"].rsplit("\n\n", 1)[1])
        self.assertEqual(context["original_request"], "search for TODO")
        self.assertEqual(context["selected_command_to_refine"]["command"], "rg -l 'TODO' .")
        self.assertEqual(context["refinement_request"], followups[1])

    @unittest.skipUnless(FISH, "Fish is unavailable")
    def test_escape_from_refinement_reopens_cached_picker_without_model_call(self):
        self.env.update(MOCK_FZF_ACTIONS="refine,enter")
        self.start_fish()
        self.send(b"\x0f")
        self.wait_for(b"PROMPT >")
        offset = self.send(b"search for TODO\r")
        self.wait_for(b"REFINE >", offset)
        offset = self.send(b"\x1b")
        self.wait_for(b"FISH_READY> ", offset)
        self.report_buffer("rg -n 'TODO' .")
        self.assertEqual(len(self.calls("codex")), 1)


if __name__ == "__main__":
    unittest.main()
