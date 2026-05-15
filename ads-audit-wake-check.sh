#!/bin/bash
# Run audit if it hasn't run today (catches wake-from-sleep after 5 PM)
TODAY=$(date +%Y-%m-%d)
LOG_DIR="$HOME/.claude/logs"
SENTINEL="$LOG_DIR/ads-audit-last-run.txt"
mkdir -p "$LOG_DIR"

LAST_RUN=$(cat "$SENTINEL" 2>/dev/null || echo "never")
CURRENT_HOUR=$(date +%H)

# Only run between 17:00-23:59 if not already run today
if [ "$LAST_RUN" != "$TODAY" ] && [ "$CURRENT_HOUR" -ge 17 ]; then
    echo "$TODAY" > "$SENTINEL"
    python3 /Users/mc/.claude/bin/daily-ads-audit.py >> "$LOG_DIR/daily-ads-audit.log" 2>&1 &
fi
