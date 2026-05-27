#!/usr/bin/env bash

# Click handler for Buildkite widget
# Usage: buildkite_click.sh [pr_index]
# - No arg: Toggle popup
# - 1, 2, 3: Open specific PR and close popup

CACHE_DIR="$HOME/tmp/sketchybar-cache"
URLS_FILE="$CACHE_DIR/urls.txt"

# Get PR index from argument
PR_INDEX="${1:-0}"

# Read URLs
if [[ ! -f "$URLS_FILE" ]]; then
    osascript -e 'display notification "Run: bk-track add <pr>" with title "No PRs Tracked"'
    exit 0
fi

mapfile -t URLS < "$URLS_FILE"
URL_COUNT=${#URLS[@]}

if [[ $URL_COUNT -eq 0 ]]; then
    osascript -e 'display notification "Run: bk-track add <pr>" with title "No PRs Tracked"'
    exit 0
fi

# If specific PR index requested, open it and close popup
if [[ $PR_INDEX -gt 0 && $PR_INDEX -le $URL_COUNT ]]; then
    open "${URLS[$((PR_INDEX - 1))]}"
    sketchybar --set bk_status popup.drawing=off
    exit 0
fi

# Single PR - open directly
if [[ $URL_COUNT -eq 1 ]]; then
    open "${URLS[0]}"
    exit 0
fi

# Multiple PRs - show selection menu
CONFIG_DIR="$HOME/.config/sketchybar"
PRS_FILE="$CONFIG_DIR/buildkite-prs.conf"
DEFAULT_REPO="canva/canva"

CHOICES=""
INDEX=0
while IFS= read -r line; do
    [[ -z "$line" || "$line" == \#* ]] && continue
    ((INDEX++))
    [[ $INDEX -gt 5 ]] && break
    
    if [[ "$line" == *":"* ]]; then
        repo="${line%%:*}"
        pr_num="${line##*:}"
    else
        repo="$DEFAULT_REPO"
        pr_num="$line"
    fi
    
    title=$(gh pr view "$pr_num" --repo "$repo" --json title,state -q '"\(.state): \(.title)"' 2>/dev/null | cut -c1-50)
    CHOICES+="#${pr_num} - ${title}\n"
done < "$PRS_FILE"

SELECTED=$(echo -e "$CHOICES" | sed '/^$/d' | osascript -e '
    set theList to paragraphs of (do shell script "cat")
    if (count of theList) > 0 then
        try
            set theChoice to choose from list theList with prompt "Select PR:" default items {item 1 of theList}
            if theChoice is false then return ""
            return item 1 of theChoice
        end try
    end if
    return ""
' 2>/dev/null)

if [[ -n "$SELECTED" && "$SELECTED" != "" ]]; then
    PR_NUM=$(echo "$SELECTED" | grep -o '#[0-9]*' | tr -d '#')
    
    # Find URL for this PR
    INDEX=0
    while IFS= read -r line; do
        [[ -z "$line" || "$line" == \#* ]] && continue
        ((INDEX++))
        
        if [[ "$line" == *":"* ]]; then
            num="${line##*:}"
        else
            num="$line"
        fi
        
        if [[ "$num" == "$PR_NUM" && $INDEX -le $URL_COUNT ]]; then
            open "${URLS[$((INDEX - 1))]}"
            exit 0
        fi
    done < "$PRS_FILE"
fi
