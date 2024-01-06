#!/bin/bash

# URL of ChatGPT
CHATGPT_URL="https://chat.openai.com/"

# Path to Google Chrome
CHROME_APP="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# Check if Google Chrome is installed
if [ -f "$CHROME_APP" ]; then
    # Open ChatGPT in Google Chrome
    open -a "Google Chrome" $CHATGPT_URL
else
    echo "Google Chrome is not installed."
fi
