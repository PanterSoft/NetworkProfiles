#!/bin/bash

# Set the active developer directory to the Xcode application
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

# Navigate to the directory containing the Xcode project
cd "$(dirname "$0")/NetworkProfilesMenueBar"

# Build the menubar application
xcodebuild -scheme NetworkProfilesMenueBar -configuration Debug

# Run the built application
open ./Build/Products/Debug/NetworkProfilesMenueBar.app
