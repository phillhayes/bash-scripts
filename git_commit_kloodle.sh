#!/bin/bash

# Pass all args to git commit
git commit "$@"

# Only proceed if commit was successful
if [ $? -eq 0 ]; then
  COMMIT_HASH=$(git rev-parse HEAD)
  MESSAGE=$(git log -1 --pretty=%B)
  DIFF=$(git show "$COMMIT_HASH" --no-color)
  PROJECT_NAME=$(basename "$(git rev-parse --show-toplevel)")
  TIMESTAMP=$(date -Iseconds)
  DATE=$(date +%Y-%m-%d)
  LOGFILE=~/second-brain/Logs/$DATE.md

  # Create log file if it doesn't exist
  touch "$LOGFILE"

  # Format commit summary
  ENTRY="\n🧩 **$PROJECT_NAME** — $TIMESTAMP\n"
  ENTRY+="💬 $MESSAGE\n"
  ENTRY+="🔍 Files Changed:\n"
  ENTRY+="$(git diff-tree --no-commit-id --name-only -r "$COMMIT_HASH" | sed 's/^/- /')\n"

  # Append to COMMITS section (create if missing)
  if ! grep -q "## COMMITS" "$LOGFILE"; then
    echo -e "\n## COMMITS\n$ENTRY" >> "$LOGFILE"
  else
    sed -i '' "/## COMMITS/ r /dev/stdin" "$LOGFILE" <<< "$ENTRY"
  fi

  echo -e "🧠 Added commit to daily log at $LOGFILE\n"

  # Optional: Kloodle payload
  # Uncomment + fix this if needed later
  # PAYLOAD=$(jq -n \
  #   --arg git_log "$DIFF" \
  #   --arg commit_message "$MESSAGE" \
  #   --argjson tags "$TAG_JSON" \
  #   --arg project "$PROJECT_NAME" \
  #   --arg timestamp "$TIMESTAMP" \
  #   '{ git_log: $git_log, tags: $tags, project: $project, timestamp: $timestamp }')

  # RESPONSE=$(curl -s -X POST https://kloodle.com/api/v2/logs/git \
  #   -H "Content-Type: application/json" \
  #   -H "X-API-KEY: YOUR_API_KEY_HERE" \
  #   -d "$PAYLOAD")

  # echo "🔁 Kloodle response:"
  # echo "$RESPONSE" | cut -c 1-1000
fi
