# Network Profiles

## Overview
Network Profiles is a SwiftUI application that allows users to create network profiles. Each profile contains information such as DHCP mode, subnet mask, IPv4 address, router, gateway, and DNS. and this profiles can then be applied to a network adapter

## Features
- Create new network profiles
- View a list of network profiles
- Delete network profiles
- Detailed view for each profile

### Installation via Homebrew
1. Tap the repository:
    ```sh
    brew tap PanterSoft/homebrew-pantersoft
    ```
2. Install the application:
    ```sh
    brew install network-profiles
    ```

## Menubar Application
The menubar application allows you to quickly access and manage your network profiles from the macOS menubar.

### How to Use
1. Set the active developer directory to the Xcode application:
    ```sh
    sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
    ```
2. Navigate to the directory containing the Xcode project:
    ```sh
    cd NetworkProfilesMenueBar
    ```
3. Build the menubar application:
    ```sh
    xcodebuild -scheme NetworkProfilesMenueBar -configuration Release
    ```
4. Run the built application:
    ```sh
    cd build/Release
    open NetworkProfilesMenueBar.app
    ```
5. You will see a network icon in the menubar.
6. Click the icon to open the menu.
7. Select "Open NetworkProfiles_cli" to launch the CLI application.
8. Select "Quit" to exit the menubar application.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
