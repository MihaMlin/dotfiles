#!/bin/bash
set -euo pipefail

readonly R="\033[0m"
readonly DIM="\033[90m"
readonly BLUE="\033[94m"
readonly SEP=" | "
readonly DOT=" · "

input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name // .model // "unknown"' 2>/dev/null)
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' 2>/dev/null | cut -d. -f1)
CWD=$(echo "$input" | jq -r '.cwd // "."' 2>/dev/null)
SESSION_START=$(echo "$input" | jq -r '.session_start_time // ""' 2>/dev/null)

TOKENS_IN=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0' 2>/dev/null)
TOKENS_OUT=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // 0' 2>/dev/null)
TOKENS_CACHED=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0' 2>/dev/null)
TOKENS_TOTAL=$(( TOKENS_IN + TOKENS_OUT + TOKENS_CACHED ))

RATE_5H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // 0' 2>/dev/null | cut -d. -f1)
RATE_RESET=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // 0' 2>/dev/null)

GIT_BRANCH=$(git -C "$CWD" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")

FILLED=$(( PCT * 20 / 100 ))
EMPTY=$(( 20 - FILLED ))
BAR=""
for _ in $(seq 1 "$FILLED" 2>/dev/null); do BAR="${BAR}█"; done
for _ in $(seq 1 "$EMPTY"  2>/dev/null); do BAR="${BAR}░"; done
[ -z "$BAR" ] && BAR="░░░░░░░░░░░░░░░░░░░░"

if [ -n "$SESSION_START" ]; then
  NOW=$(date +%s)
  START=$(date -d "$SESSION_START" +%s 2>/dev/null || echo "$NOW")
  ELAPSED=$(( NOW - START ))
  HRS=$(( ELAPSED / 3600 ))
  MINS=$(( (ELAPSED % 3600) / 60 ))
  [ "$HRS" -eq 0 ] && CLOCK="${MINS}m" || CLOCK="${HRS}hr ${MINS}m"
else
  CLOCK="$(date +%H:%M)"
fi

if [ "$RATE_RESET" -gt 0 ] 2>/dev/null; then
  NOW=$(date +%s)
  REM=$(( RATE_RESET - NOW ))
  [ "$REM" -lt 0 ] && REM=0
  R_H=$(( REM / 3600 ))
  R_M=$(( (REM % 3600) / 60 ))
  RTIMER="${R_H}hr ${R_M}m"
else
  RTIMER="5hr 0m"
fi

# line 1
if [ -n "$GIT_BRANCH" ]; then
    printf "${DIM}%-12s${R}${SEP}${DIM}%s${R} ${DIM}%3s%%${R}${SEP}${BLUE}%s${R}\n" \
      "$MODEL" "$BAR" "$PCT" "$GIT_BRANCH"
else
    printf "${DIM}%-12s${R}${SEP}${DIM}%s${R} ${DIM}%3s%%${R}\n" \
      "$MODEL" "$BAR" "$PCT"
fi

# line 2
printf "${DIM}total:%-6s${R}${SEP}${DIM}in:%s${R}${DOT}${DIM}out:%s${R}${DOT}${DIM}cached:%s${R}\n" \
  "$TOKENS_TOTAL" "$TOKENS_IN" "$TOKENS_OUT" "$TOKENS_CACHED"

# line 3
printf "${DIM}plan:%-7s${R}${SEP}${DIM}reset:%-10s${R}\n" \
  "${RATE_5H}%" "$RTIMER"
