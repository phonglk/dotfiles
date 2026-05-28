#!/usr/bin/env bash

# Cursor usage/quota widget for SketchyBar.
# Reads Cursor's signed-in desktop token from local app state, keeps it in memory
# only, and calls Cursor-owned endpoints for derived usage fields.

CONFIG_FILE="${CURSOR_USAGE_CONFIG:-$HOME/.config/sketchybar/cursor_usage.conf}"
CACHE_DIR="${CURSOR_USAGE_CACHE_DIR:-$HOME/tmp/sketchybar-cache}"
CACHE_FILE="$CACHE_DIR/cursor_usage.json"
STATE_DB="${CURSOR_USAGE_STATE_DB:-$HOME/Library/Application Support/Cursor/User/globalStorage/state.vscdb}"
SKETCHYBAR_CMD="${SKETCHYBAR_CMD:-sketchybar}"
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

CURSOR_USAGE_EMAIL=""
CURSOR_USAGE_WARN_PCT=80
CURSOR_USAGE_CRIT_PCT=95
CURSOR_USAGE_CACHE_TTL_SECONDS=60

GREEN="0xffa3be8c"
RED="0xffbf616a"
YELLOW="0xffebcb8b"
GREY="0xff4c566a"
WHITE="0xffd8dee9"

[[ -f "$CONFIG_FILE" ]] && source "$CONFIG_FILE"

GREEN="${CURSOR_USAGE_COLOR_OK:-$GREEN}"
RED="${CURSOR_USAGE_COLOR_CRIT:-$RED}"
YELLOW="${CURSOR_USAGE_COLOR_WARN:-$YELLOW}"
GREY="${CURSOR_USAGE_COLOR_MUTED:-$GREY}"
WHITE="${CURSOR_USAGE_COLOR_RESET:-$WHITE}"

mkdir -p "$CACHE_DIR"

bar() {
    "$SKETCHYBAR_CMD" "$@"
}

set_popup_row() {
    local item="$1"
    local icon="$2"
    local icon_color="$3"
    local label="$4"

    bar --set "$item" \
        drawing=on \
        icon="$icon" \
        icon.color="$icon_color" \
        label="$label"
}

hide_popup_rows() {
    for item in cursor_usage_pct cursor_usage_reset cursor_usage_status; do
        bar --set "$item" drawing=off
    done
}

set_main() {
    local label="$1"
    local color="$2"

    bar --set cursor_usage \
        label="$label" \
        popup.background.border_color="$color"
    bar --set cursor_usage_icon \
        background.color="$color"
    bar --set _cursor_usage \
        background.border_color="$color"
}

age_label() {
    local updated_at="$1"
    local now diff

    now=$(date +%s)
    diff=$((now - updated_at))
    if [[ $diff -ge 3600 ]]; then
        printf '%dh' "$((diff / 3600))"
    elif [[ $diff -ge 60 ]]; then
        printf '%dm' "$((diff / 60))"
    else
        printf '%ds' "$diff"
    fi
}

use_cache_or_error() {
    local label="$1"
    local color="$2"

    if [[ -f "$CACHE_FILE" ]] && jq -e '.label and .updatedAt' "$CACHE_FILE" >/dev/null 2>&1; then
        local cached_label updated_at age
        cached_label=$(jq -r '.label' "$CACHE_FILE")
        updated_at=$(jq -r '.updatedAt' "$CACHE_FILE")
        age=$(age_label "$updated_at")
        set_main "$cached_label · $age" "$YELLOW"
        set_popup_row cursor_usage_pct "󰁝" "$YELLOW" "Stale data · $age old"
        set_popup_row cursor_usage_reset "󰃭" "$WHITE" "$(jq -r '.resetDetail // "Reset unknown"' "$CACHE_FILE")"
        set_popup_row cursor_usage_status "󰅚" "$color" "$label"
        exit 0
    fi

    set_main "$label" "$color"
    hide_popup_rows
    exit 0
}

require_cmd() {
    local cmd="$1"
    if ! command -v "$cmd" >/dev/null 2>&1; then
        use_cache_or_error "Install $cmd" "$RED"
    fi
}

format_date() {
    local ms="$1"
    if [[ -z "$ms" || "$ms" == "null" || "$ms" == "0" ]]; then
        printf 'unknown'
        return
    fi
    date -r "$((ms / 1000))" '+%b %e' | sed 's/  / /'
}

format_datetime() {
    local ms="$1"
    if [[ -z "$ms" || "$ms" == "null" || "$ms" == "0" ]]; then
        printf 'Reset unknown'
        return
    fi
    date -r "$((ms / 1000))" '+%b %e %H:%M' | sed 's/  / /'
}

post_rpc() {
    local token="$1"
    local method="$2"
    local payload="$3"
    local output="$4"
    local code

    code=$(curl -sS -o "$output" -w '%{http_code}' \
        -X POST \
        -H "Authorization: Bearer $token" \
        -H 'Content-Type: application/json' \
        -H 'Connect-Protocol-Version: 1' \
        --data "$payload" \
        "https://api2.cursor.sh/aiserver.v1.DashboardService/$method" 2>/dev/null || true)

    [[ "$code" == "200" ]]
}

require_cmd sqlite3
require_cmd curl
require_cmd jq

if ! command -v "$SKETCHYBAR_CMD" >/dev/null 2>&1; then
    exit 0
fi

if [[ -f "$CACHE_FILE" ]] && jq -e '.label and .updatedAt and .color' "$CACHE_FILE" >/dev/null 2>&1; then
    cached_at=$(jq -r '.updatedAt' "$CACHE_FILE")
    now=$(date +%s)
    if [[ $((now - cached_at)) -lt "$CURSOR_USAGE_CACHE_TTL_SECONDS" ]]; then
        set_main \
            "$(jq -r '.label' "$CACHE_FILE")" \
            "$(jq -r '.color // "0xffa3be8c"' "$CACHE_FILE")"
        set_popup_row cursor_usage_pct \
            "󰁝" \
            "$(jq -r '.color // "0xffa3be8c"' "$CACHE_FILE")" \
            "$(jq -r '.percent // "Usage unknown"' "$CACHE_FILE")"
        set_popup_row cursor_usage_reset \
            "󰃭" \
            "$WHITE" \
            "$(jq -r '.resetDetail // "Reset unknown"' "$CACHE_FILE")"
        set_popup_row cursor_usage_status \
            "󰒓" \
            "$GREY" \
            "$(jq -r '.status // "Status unknown"' "$CACHE_FILE")"
        exit 0
    fi
fi

[[ -r "$STATE_DB" ]] || use_cache_or_error "No Cursor DB" "$RED"

token=$(sqlite3 "$STATE_DB" "select value from ItemTable where key='cursorAuth/accessToken';" 2>/dev/null || true)
cached_email=$(sqlite3 "$STATE_DB" "select value from ItemTable where key='cursorAuth/cachedEmail';" 2>/dev/null || true)
membership=$(sqlite3 "$STATE_DB" "select value from ItemTable where key='cursorAuth/stripeMembershipType';" 2>/dev/null || true)

[[ -n "$token" ]] || use_cache_or_error "Cursor login" "$RED"

target_email="$cached_email"
if [[ -n "$CURSOR_USAGE_EMAIL" ]]; then
    if [[ "$cached_email" != "$CURSOR_USAGE_EMAIL" ]]; then
        use_cache_or_error "Wrong acct" "$RED"
    fi
    target_email="$CURSOR_USAGE_EMAIL"
fi
[[ -n "$target_email" ]] || use_cache_or_error "No email" "$RED"

tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT

teams_file="$tmp_dir/teams.json"
spend_file="$tmp_dir/spend.json"
limits_file="$tmp_dir/limits.json"
hard_file="$tmp_dir/hard.json"
fast_file="$tmp_dir/fast.json"

post_rpc "$token" GetTeams '{}' "$teams_file" || use_cache_or_error "Cursor API" "$RED"

team_id=$(jq -r '.. | objects | select(has("teamId")) | .teamId | select(. != null)' "$teams_file" | head -n 1)
if [[ -z "$team_id" ]]; then
    team_id=$(jq -r '.. | objects | select(has("id")) | .id | select(type=="number")' "$teams_file" | head -n 1)
fi
[[ -n "$team_id" ]] || use_cache_or_error "No team" "$RED"

spend_payload=$(jq -cn \
    --argjson teamId "$team_id" \
    --arg email "$target_email" \
    '{teamId:$teamId,page:1,pageSize:10,searchTerm:$email}')

post_rpc "$token" GetTeamSpend "$spend_payload" "$spend_file" || use_cache_or_error "Spend API" "$RED"

member_json=$(jq -c --arg email "$target_email" '.teamMemberSpend[]? | select(.email == $email)' "$spend_file" | head -n 1)
if [[ -z "$member_json" ]]; then
    member_json=$(jq -c '.teamMemberSpend[0] // empty' "$spend_file")
fi
[[ -n "$member_json" ]] || use_cache_or_error "No usage" "$RED"

usage_cents=$(jq -r '.overallSpendCents // empty' <<<"$member_json")
limit_dollars=$(jq -r '.effectivePerUserLimitDollars // .monthlyLimitDollars // .hardLimitOverrideDollars // empty' <<<"$member_json")
next_cycle_ms=$(jq -r '.nextCycleStart // empty' "$spend_file")
cycle_start_ms=$(jq -r '.subscriptionCycleStart // empty' "$spend_file")
role=$(jq -r '.role // "team"' <<<"$member_json")

[[ -n "$usage_cents" && -n "$limit_dollars" && "$limit_dollars" != "0" ]] || use_cache_or_error "No limit" "$RED"

post_rpc "$token" GetUsageLimitStatusAndActiveGrants '{}' "$limits_file" || true
post_rpc "$token" GetHardLimit '{}' "$hard_file" || true
post_rpc "$token" GetFastRequests '{}' "$fast_file" || true

limit_type=$(jq -r '.usageLimitPolicyStatus.limitType // "team"' "$limits_file" 2>/dev/null || printf 'team')
no_usage_based=$(jq -r '.noUsageBasedAllowed // "unknown"' "$hard_file" 2>/dev/null || printf 'unknown')
request_quota=$(jq -r '.requestQuota // empty' "$fast_file" 2>/dev/null || true)

usage_exact=$(awk -v cents="$usage_cents" 'BEGIN { printf "%.2f", cents / 100 }')
limit_exact=$(awk -v dollars="$limit_dollars" 'BEGIN { printf "%.2f", dollars }')
pct=$(awk -v cents="$usage_cents" -v dollars="$limit_dollars" 'BEGIN { printf "%.0f", cents / dollars }')

reset_detail=$(format_datetime "$next_cycle_ms")
cycle_start_label=$(format_date "$cycle_start_ms")

color="$GREEN"
if [[ "$pct" -ge "$CURSOR_USAGE_CRIT_PCT" ]]; then
    color="$RED"
elif [[ "$pct" -ge "$CURSOR_USAGE_WARN_PCT" ]]; then
    color="$YELLOW"
fi

main_label="${pct}%"
pct_label="${pct}% used · \$${usage_exact}/\$${limit_exact}"
reset_popup_label="Reset ${reset_detail} · from ${cycle_start_label}"
status_label="${membership:-cursor} · ${limit_type}"
if [[ -n "$request_quota" ]]; then
    status_label="${status_label} · ${request_quota} req"
fi
if [[ "$no_usage_based" == "true" ]]; then
    status_label="${status_label} · no overage"
fi

set_main "$main_label" "$color"
set_popup_row cursor_usage_pct "󰁝" "$color" "$pct_label"
set_popup_row cursor_usage_reset "󰃭" "$WHITE" "$reset_popup_label"
set_popup_row cursor_usage_status "󰒓" "$GREY" "$status_label"

jq -n \
    --arg mainLabel "$main_label" \
    --arg percent "$pct_label" \
    --arg resetDetail "$reset_popup_label" \
    --arg status "$status_label" \
    --arg role "$role" \
    --arg color "$color" \
    --argjson updatedAt "$(date +%s)" \
    '{label:$mainLabel,percent:$percent,resetDetail:$resetDetail,status:$status,role:$role,color:$color,updatedAt:$updatedAt}' \
    > "$CACHE_FILE"
