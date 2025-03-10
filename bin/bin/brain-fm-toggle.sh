#!/bin/bash

# Store the currently focused window ID
CURRENT_WINDOW=$(xdotool getwindowfocus)

# Find the window ID of the browser with brain.fm
WINDOW_ID=$(xdotool search --name "brain.fm" | head -1)

if [ -z "$WINDOW_ID" ]; then
  echo "brain.fm window not found"
  exit 1
fi

# Focus the window and send the space key
xdotool windowactivate $WINDOW_ID
xdotool key space

# Return focus to the original window
xdotool windowactivate $CURRENT_WINDOW
