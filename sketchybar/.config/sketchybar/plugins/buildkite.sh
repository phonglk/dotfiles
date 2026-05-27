#!/usr/bin/env bash

# GitHub PR / CI Status Plugin for SketchyBar
# Clean display of PR status with check counts

CONFIG_DIR="$HOME/.config/sketchybar"
PRS_FILE="$CONFIG_DIR/buildkite-prs.conf"
CACHE_DIR="$HOME/tmp/sketchybar-cache"
LOG_FILE="$CACHE_DIR/buildkite.log"

mkdir -p "$CACHE_DIR"

log() { [[ "${DEBUG:-0}" == "1" ]] && echo "[$(date '+%H:%M:%S')] $*" >> "$LOG_FILE"; }

DEFAULT_REPO="canva/canva"
[[ -f "$CONFIG_DIR/buildkite.conf" ]] && source "$CONFIG_DIR/buildkite.conf"

# Colors
GREEN="0xffa3be8c"
RED="0xffbf616a"
YELLOW="0xffebcb8b"
GREY="0xff4c566a"
WHITE="0xffd8dee9"

# Count occurrences in string
count() { echo "$1" | grep -o "$2" 2>/dev/null | wc -l | tr -d ' '; }

# Check requirements
if ! command -v gh &>/dev/null; then
    sketchybar --set bk_status label="Install gh CLI" icon=󰅚 icon.color="$RED"
    exit 1
fi

if ! gh auth status &>/dev/null 2>&1; then
    sketchybar --set bk_status label="gh auth login" icon=󰅚 icon.color="$RED"
    exit 1
fi

# No PRs
if [[ ! -f "$PRS_FILE" ]] || [[ ! -s "$PRS_FILE" ]]; then
    sketchybar --set bk_status label="No PRs" icon=󰝦 icon.color="$GREY"
    for i in 1 2 3; do sketchybar --set "bk_pr$i" drawing=off; done
    exit 0
fi

# Process PRs
log "===== Update started ====="
> "$CACHE_DIR/urls.txt"

pr_idx=0
total_pass=0 total_fail=0 total_run=0

for i in 1 2 3; do sketchybar --set "bk_pr$i" drawing=off; done

while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    ((pr_idx++))
    [[ $pr_idx -gt 3 ]] && break

    # Parse line
    if [[ "$line" == *":"* ]]; then
        repo="${line%%:*}"
        pr_num="${line##*:}"
    else
        repo="$DEFAULT_REPO"
        pr_num="$line"
    fi

    log "PR #$pr_num"

    # Fetch PR data
    state=$(gh pr view "$pr_num" --repo "$repo" --json state -q '.state' 2>/dev/null)
    title=$(gh pr view "$pr_num" --repo "$repo" --json title -q '.title' 2>/dev/null)
    checks=$(gh pr view "$pr_num" --repo "$repo" --json statusCheckRollup -q '.statusCheckRollup' 2>/dev/null)

    [[ -z "$state" ]] && continue

    # Count checks
    pending=0 failed=0 success=0
    if [[ -n "$checks" && "$checks" != "null" ]]; then
        pending=$(($(count "$checks" '"status":"IN_PROGRESS"') + $(count "$checks" '"status":"QUEUED"') + $(count "$checks" '"state":"PENDING"')))
        failed=$(($(count "$checks" '"conclusion":"FAILURE"') + $(count "$checks" '"conclusion":"ERROR"') + $(count "$checks" '"state":"FAILURE"')))
        success=$(($(count "$checks" '"conclusion":"SUCCESS"') + $(count "$checks" '"conclusion":"NEUTRAL"') + $(count "$checks" '"state":"SUCCESS"')))
    fi

    log "  checks: ✓$success ⟳$pending ✗$failed"

    # Determine status
    if [[ "$state" == "MERGED" ]]; then
        icon_color="$GREEN"; ((total_pass++))
    elif [[ "$state" == "CLOSED" ]]; then
        icon_color="$RED"; ((total_fail++))
    elif [[ $failed -gt 0 ]]; then
        icon_color="$RED"; ((total_fail++))
    elif [[ $pending -gt 0 ]]; then
        icon_color="$YELLOW"; ((total_run++))
    else
        icon_color="$GREEN"; ((total_pass++))
    fi

    # Format: "PR #123 · ✓10 · title..."
    short_title=$(echo "$title" | cut -c1-25)
    [[ ${#title} -gt 25 ]] && short_title="${short_title}…"
    
    label="#${pr_num}"
    [[ $success -gt 0 ]] && label="$label ✓$success"
    [[ $pending -gt 0 ]] && label="$label ⟳$pending"
    [[ $failed -gt 0 ]] && label="$label ✗$failed"
    label="$label · $short_title"

    sketchybar --set "bk_pr$pr_idx" \
        drawing=on \
        icon.color="$icon_color" \
        label="$label"

    echo "https://github.com/${repo}/pull/${pr_num}" >> "$CACHE_DIR/urls.txt"

done < "$PRS_FILE"

# Freshness
ts_file="$CACHE_DIR/last_update"
now=$(date +%s)
fresh="now"
if [[ -f "$ts_file" ]]; then
    diff=$((now - $(cat "$ts_file")))
    [[ $diff -ge 60 ]] && fresh="$((diff/60))m"
    [[ $diff -ge 5 && $diff -lt 60 ]] && fresh="${diff}s"
fi

# Overall status
if [[ $total_fail -gt 0 ]]; then
    status_icon="󰅚"; status_color="$RED"
elif [[ $total_run -gt 0 ]]; then
    status_icon="󰑮"; status_color="$YELLOW"
else
    status_icon="󰄬"; status_color="$GREEN"
fi

# Summary: "2 PRs · ✓2 · 30s"
summary="${pr_idx}PR"
[[ $pr_idx -gt 1 ]] && summary="${pr_idx}PRs"
[[ $total_pass -gt 0 ]] && summary="$summary ✓$total_pass"
[[ $total_run -gt 0 ]] && summary="$summary ⟳$total_run"
[[ $total_fail -gt 0 ]] && summary="$summary ✗$total_fail"
summary="$summary · $fresh"

sketchybar --set bk_status \
    icon="$status_icon" \
    icon.color="$status_color" \
    label="$summary" \
    background.border_color="$status_color" \
    popup.background.border_color="$status_color"

echo "$now" > "$ts_file"

# Notifications
state_file="$CACHE_DIR/state"
current="${total_pass}:${total_run}:${total_fail}"
if [[ -f "$state_file" ]]; then
    prev_run=$(cut -d: -f2 < "$state_file")
    if [[ $prev_run -gt 0 && $total_run -eq 0 ]]; then
        if [[ $total_fail -gt 0 ]]; then
            osascript -e "display notification \"$total_fail PR(s) failed\" with title \"CI ✗\" sound name \"Basso\"" 2>/dev/null
        else
            osascript -e "display notification \"All checks passed!\" with title \"CI ✓\" sound name \"Glass\"" 2>/dev/null
        fi
    fi
fi
echo "$current" > "$state_file"

log "Done: ✓$total_pass ⟳$total_run ✗$total_fail"
