#!/usr/bin/env bash

# Preberi JSON iz stdin
input=$(cat)

# Izvleci podatke z jq
MODEL=$(echo "$input" | jq -r '.model // "unknown"' 2>/dev/null || echo "unknown")
GIT_BRANCH=$(git -C "$(echo "$input" | jq -r '.cwd // "."' 2>/dev/null)" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
CTX_USED=$(echo "$input" | jq -r '.context_window.used_tokens // 0' 2>/dev/null || echo 0)
CTX_MAX=$(echo "$input" | jq -r '.context_window.total_tokens // 200000' 2>/dev/null || echo 200000)
TOKENS_IN=$(echo "$input" | jq -r '.usage.input_tokens // 0' 2>/dev/null || echo 0)
TOKENS_OUT=$(echo "$input" | jq -r '.usage.output_tokens // 0' 2>/dev/null || echo 0)
TOKENS_CACHED=$(echo "$input" | jq -r '.usage.cache_read_input_tokens // 0' 2>/dev/null || echo 0)
TOKENS_TOTAL=$(( TOKENS_IN + TOKENS_OUT + TOKENS_CACHED ))
SESSION_START=$(echo "$input" | jq -r '.session_start_time // ""' 2>/dev/null || echo "")

# ANSI barve (brightBlack = dark gray, brightBlue = svetlo modra)
RESET="\033[0m"
BRIGHT_BLACK="\033[90m"
BRIGHT_BLUE="\033[94m"
SEP=" | "
DOT=" · "

# --- CONTEXT BAR ---
if [ "$CTX_MAX" -gt 0 ] 2>/dev/null; then
  PCT=$(( CTX_USED * 100 / CTX_MAX ))
  BAR_TOTAL=20
  BAR_FILLED=$(( PCT * BAR_TOTAL / 100 ))
  BAR_EMPTY=$(( BAR_TOTAL - BAR_FILLED ))
  BAR=$(printf '%0.s█' $(seq 1 $BAR_FILLED 2>/dev/null))$(printf '%0.s░' $(seq 1 $BAR_EMPTY 2>/dev/null))
  CTX_DISPLAY="${BAR} ${PCT}%"
else
  CTX_DISPLAY="ctx: ?"
fi

# --- SESSION CLOCK ---
if [ -n "$SESSION_START" ]; then
  NOW=$(date +%s)
  START=$(date -d "$SESSION_START" +%s 2>/dev/null || echo $NOW)
  ELAPSED=$(( NOW - START ))
  HRS=$(( ELAPSED / 3600 ))
  MINS=$(( (ELAPSED % 3600) / 60 ))
  if [ $HRS -gt 0 ]; then
    CLOCK="${HRS}hr ${MINS}m"
  else
    CLOCK="${MINS}m"
  fi
else
  CLOCK="$(date +%H:%M)"
fi

# --- RESET TIMER (čas do naslednjega 5h bloka) ---
# Claude Code bloki so 5ur, izračunamo preostali čas
BLOCK_SECS=$(( 5 * 3600 ))
if [ -n "$SESSION_START" ]; then
  NOW=$(date +%s)
  START=$(date -d "$SESSION_START" +%s 2>/dev/null || echo $NOW)
  ELAPSED=$(( NOW - START ))
  REMAINING=$(( BLOCK_SECS - (ELAPSED % BLOCK_SECS) ))
  R_HRS=$(( REMAINING / 3600 ))
  R_MINS=$(( (REMAINING % 3600) / 60 ))
  RESET_TIMER="reset: ${R_HRS}hr ${R_MINS}m"
else
  RESET_TIMER="reset: 5hr 0m"
fi

# --- IZPIS VRSTIC ---
# Vrstica 1: model · ctx-bar | git-branch
LINE1="${BRIGHT_BLACK}${MODEL}${RESET}${DOT}${BRIGHT_BLACK}${CTX_DISPLAY}${RESET}${SEP}${BRIGHT_BLUE}${GIT_BRANCH}${RESET}"

# Vrstica 2: cached · input · output · total · reset-timer
LINE2="${BRIGHT_BLACK}cached:${TOKENS_CACHED}${RESET}${DOT}${BRIGHT_BLACK}in:${TOKENS_IN}${RESET}${DOT}${BRIGHT_BLACK}out:${TOKENS_OUT}${RESET}${DOT}${BRIGHT_BLACK}total:${TOKENS_TOTAL}${RESET}${DOT}${BRIGHT_BLACK}${RESET_TIMER}${RESET}"

# Vrstica 3: session clock · reset timer
LINE3="${BRIGHT_BLACK}session: ${CLOCK}${RESET}${DOT}${BRIGHT_BLACK}${RESET_TIMER}${RESET}"

printf "%b\n%b\n%b\n" "$LINE1" "$LINE2" "$LINE3"
