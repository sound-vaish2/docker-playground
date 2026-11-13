#!/bin/bash
# Usage: lesson [number]
DIR=/opt/lessons

if [ $# -eq 0 ]; then
  echo "Available lessons:"
  for f in "$DIR"/*.md; do
    n=$(basename "$f" | cut -d- -f1)
    echo "  $((10#$n))  $(head -n1 "$f" | sed 's/^# *//')"
  done
  echo
  echo "Open one with: lesson <number>"
  exit 0
fi

f=$(ls "$DIR"/"$(printf '%02d' "$1")"-*.md 2>/dev/null | head -n1)
[ -z "$f" ] && { echo "No lesson $1. Run 'lesson' to list."; exit 1; }
${PAGER:-less} "$f"
