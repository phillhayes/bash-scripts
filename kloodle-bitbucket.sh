#!/bin/bash

FILE1=~/.ssh/config
FILE2=~/.ssh/config_kloodle
TEMP_FILE=/tmp/temp_config

# Check if FILE1 exists
if [ ! -f "$FILE1" ]; then
    echo "Error: $FILE1 does not exist."
    exit 1
fi

# Check if FILE2 exists
if [ ! -f "$FILE2" ]; then
    echo "Error: $FILE2 does not exist."
    exit 1
fi

# Move FILE1 to the temporary file
mv "$FILE1" "$TEMP_FILE"

# Move FILE2 to FILE1's original location
mv "$FILE2" "$FILE1"

# Move the temporary file (original FILE1) to FILE2's original location
mv "$TEMP_FILE" "$FILE2"

echo "Files swapped: '$FILE1' and '$FILE2'"

cat $FILE1
