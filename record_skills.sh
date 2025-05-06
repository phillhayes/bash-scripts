#!/bin/bash

set -e  # Exit on error

# Define your variables
REPO_NAME=$(basename `git rev-parse --show-toplevel`)
BRANCH=$(git rev-parse --abbrev-ref HEAD)
DIFF_DIR="$HOME/diffs"
mkdir -p $DIFF_DIR  # Ensure the directory exists

# Replace slashes in branch name with underscores for file saving
SAFE_BRANCH=$(echo "$BRANCH" | sed 's/\//_/g')
DIFF_FILE="$DIFF_DIR/diff_$SAFE_BRANCH.txt"

KLOODLE_API="https://your-kloodle-domain.com/api/upload-diff"
API_TOKEN="YOUR_KLOODLE_API_TOKEN"

# Print repo name and branch info
echo "Repository Name: $REPO_NAME"
echo "Current Branch: $BRANCH"
echo "Diff File Path: $DIFF_FILE"

# Ensure master is up to date
echo "Fetching latest master branch..."
git fetch origin master

# Print the files that differ between branches
echo "Files changed between origin/master and $BRANCH:"
git diff --name-only origin/master..$BRANCH

# Get the git diff between origin/master and the current branch
echo "Running git diff between origin/master and $BRANCH..."
git diff origin/master..$BRANCH > $DIFF_FILE

# Show the entire diff if it exists
if [ -s $DIFF_FILE ]; then
    echo "Generated diff file:"
    cat $DIFF_FILE  # Print the entire diff file
else
    echo "No changes detected between origin/master and $BRANCH."
    rm $DIFF_FILE  # Cleanup empty diff file
    exit 0
fi

# Upload the diff to Kloodle
echo "Uploading diff to Kloodle..."
RESPONSE=$(curl -s -X POST $KLOODLE_API \
-H "Authorization: Bearer $API_TOKEN" \
-H "Content-Type: multipart/form-data" \
-F "repo_name=$REPO_NAME" \
-F "branch=$BRANCH" \
-F "file=@$DIFF_FILE")

# Check if the upload was successful
if echo "$RESPONSE" | grep -q '"success":true'; then
    echo "Diff uploaded successfully!"
    echo "Response: $RESPONSE"
else
    echo "Failed to upload diff. Response:"
    echo "$RESPONSE"
fi

# Cleanup temporary file
// rm $DIFF_FILE
