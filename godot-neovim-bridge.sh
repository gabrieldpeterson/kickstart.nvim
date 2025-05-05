#!/bin/bash
# Save as ~/godot-neovim-bridge.sh and make executable with: chmod +x ~/godot-neovim-bridge.sh

PROJECT_PATH="$1"
FILE_PATH="$2"
LINE="$3"
COL="$4"

# Create a unique ID for this project to use in tab titles
PROJECT_ID=$(basename "$PROJECT_PATH")

# Check if Kitty is already running
if pgrep -x "kitty" > /dev/null; then
    # Kitty is running
    
    # Check if a tab with this project already exists
    if kitty @ ls | grep -q "$PROJECT_ID"; then
        # Tab exists, focus it
        kitty @ focus-tab --match "title:$PROJECT_ID"
        
        # Send command to open the file
        kitty @ send-text --match "title:$PROJECT_ID" ":e $FILE_PATH\r:call cursor($LINE,$COL)\r"
    else
        # Tab doesn't exist, create a new tab with Neovim
        kitty @ new-window --tab --title "$PROJECT_ID" --keep-focus=no --cwd "$PROJECT_PATH" /opt/homebrew/bin/nvim -n "$FILE_PATH" "+call cursor($LINE,$COL)"
    fi
else
    # Kitty isn't running, launch it with Neovim
    /opt/homebrew/bin/kitty --title "$PROJECT_ID" --directory="$PROJECT_PATH" /opt/homebrew/bin/nvim -n "$FILE_PATH" "+call cursor($LINE,$COL)" &
fi
