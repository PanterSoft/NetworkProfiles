#!/bin/bash

# Navigate to the directory containing the built application
cd "$(dirname "$0")/NetworkProfilesMenueBar/Build/Products/Debug"

# Run the built application
open NetworkProfilesMenueBar.app
