#!/bin/bash

# --- Configuration ---
DEST_DIR="$HOME/Dropbox/flameshot"
FILENAME="Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png"
FULL_PATH="$DEST_DIR/$FILENAME"
# Max seconds to wait for Dropbox to sync/index the file
MAX_RETRIES=10

# --- 1. Save the Image ---
mkdir -p "$DEST_DIR"
cat > "$FULL_PATH"

# Verify file was saved locally
if [ ! -f "$FULL_PATH" ]; then
    notify-send -u critical "Flameshot Error" "Failed to save file to disk."
    exit 1
fi

# --- 2. Get Dropbox Link (With Retry & Cleanup) ---
# We loop because Dropbox takes a moment to index the new file.
LINK=""
Attempt=1

while [ $Attempt -le $MAX_RETRIES ]; do
    # 1. Run command
    # 2. Redirect stderr (2>) to /dev/null to hide the DeprecationWarning
    # 3. Use grep to extract only the URL starting with http/https
    RAW_OUTPUT=$(dropbox sharelink "$FULL_PATH" 2>/dev/null)
    LINK=$(echo "$RAW_OUTPUT" | grep -o 'https://[^[:space:]]*')
    
    if [[ -n "$LINK" ]]; then
        break
    fi
    
    sleep 1
    ((Attempt++))
done

# --- 3. Finalize ---
if [[ -n "$LINK" ]]; then
    # Detect Clipboard tool
    if [ "$XDG_SESSION_TYPE" == "wayland" ]; then
        echo -n "$LINK" | wl-copy
    else
        echo -n "$LINK" | xclip -selection clipboard
    fi

    notify-send -i "$FULL_PATH" "Dropbox Upload" "Link copied to clipboard!"
else
    # Check if the process timed out or if Dropbox isn't running
    STATUS=$(dropbox status 2>/dev/null)
    notify-send -u critical "Dropbox Error" "Timed out getting link. Status: ${STATUS:-'Not Running'}"
fi
