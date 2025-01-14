#!/bin/bash

# Navigate to the directory containing the built application
cd "$(dirname "$0")/NetworkProfilesMenueBar/build/Release"

# Run the built application
open NetworkProfilesMenueBar.app
