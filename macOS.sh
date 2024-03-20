#!/usr/bin/env zsh

xcode-select --install

echo "Complete the installation of Xcode Command Line Tools before proceeding."
echo "Press enter to continue..."
read

# Get the absolute path to the image
IMAGE_PATH="${HOME}/dotfiles/settings/Desktop.jpeg"

# AppleScript command to set the desktop background
osascript <<EOF
tell application "System Events"
    set desktopCount to count of desktops
    repeat with desktopNumber from 1 to desktopCount
        tell desktop desktopNumber
            set picture to "$IMAGE_PATH"
        end tell
    end repeat
end tell
EOF
