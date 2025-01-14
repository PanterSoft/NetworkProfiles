//
//  NetworkProfilesMenueBarApp.swift
//  NetworkProfilesMenueBar
//
//  Created by Nico Mattes on 14.01.25.
//

import SwiftUI
import SwiftData

@main
struct NetworkProfilesMenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var settingsWindow: NSWindow?
    var createProfileWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Load SwiftData model
        loadSwiftDataModel()

        // Set up the menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "network", accessibilityDescription: "Network Profiles")
            button.image?.isTemplate = true // Adapts to light/dark mode
        }

        // Create the menu
        updateMenu()

        // Set the initial dock icon state
        setInitialDockIconState()
    }

    func loadSwiftDataModel() {
        // Initialize SwiftData model
        SwiftDataHelper.initializeModel()
    }

    func updateMenu() {
        let menu = NSMenu()

        menu.addItem(NSMenuItem(title: "Create Profile", action: #selector(createProfileAction), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())

        // Load existing config
        if let config = SwiftDataHelper.loadConfig() {
            for profile in config.profiles {
                menu.addItem(NSMenuItem(title: profile.profileName, action: #selector(applyProfile(_:)), keyEquivalent: ""))
            }
        }

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))

        statusItem.menu = menu
    }

    @objc func applyProfile(_ sender: NSMenuItem) {
        if let config = SwiftDataHelper.loadConfig() {
            do {
                try SwiftDataHelper.applyProfileByName(config: config, profileName: sender.title)
            } catch {
                SwiftDataHelper.showErrorPopup(message: "Error applying profile: \(error.localizedDescription)")
            }
        } else {
            SwiftDataHelper.showErrorPopup(message: "Failed to load configuration.")
        }
    }

    @objc func openSettings() {
        if settingsWindow == nil {
            let settingsView = SettingsView() // SwiftUI Settings View
            settingsWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 300, height: 150),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            settingsWindow?.center()
            settingsWindow?.title = "Settings"
            settingsWindow?.isReleasedWhenClosed = false
            settingsWindow?.contentView = NSHostingView(rootView: settingsView)
        }
        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }

    @objc func createProfileAction() {
        if createProfileWindow == nil {
            let createProfileView = CreateProfileView(appDelegate: self) // SwiftUI Create Profile View
            createProfileWindow = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            createProfileWindow?.center()
            createProfileWindow?.title = "Create Profile"
            createProfileWindow?.isReleasedWhenClosed = false
            createProfileWindow?.contentView = NSHostingView(rootView: createProfileView)
        }
        createProfileWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func setInitialDockIconState() {
        let isVisible = UserDefaults.standard.bool(forKey: "isDockIconVisible")
        NSApp.setActivationPolicy(isVisible ? .regular : .accessory)
    }
}

struct CreateProfileView: View {
    @State private var profileName: String = ""
    @State private var mode: String = "manual"
    @State private var ipv4Address: String = ""
    @State private var router: String = ""
    @State private var subnetMask: String = ""
    @State private var dnsServers: String = ""
    @State private var interfaceName: String = ""

    var appDelegate: AppDelegate

    var body: some View {
        VStack {
            TextField("Profile Name", text: $profileName)
            Picker("Mode", selection: $mode) {
                Text("Manual").tag("manual")
                Text("DHCP").tag("dhcp")
            }
            .pickerStyle(SegmentedPickerStyle())

            if mode == "manual" {
                TextField("IPv4 Address", text: $ipv4Address)
                TextField("Router", text: $router)
                TextField("Subnet Mask", text: $subnetMask)
            }

            TextField("DNS Servers (comma separated)", text: $dnsServers)
            TextField("Interface Name", text: $interfaceName)

            Button("Create Profile") {
                // Implement the create profile action
                let dnsServersArray = dnsServers.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                let newProfile = NetworkProfile(
                    profileName: profileName,
                    ipv4Address: mode == "manual" ? ipv4Address : nil,
                    router: mode == "manual" ? router : nil,
                    subnetMask: mode == "manual" ? subnetMask : nil,
                    dnsServers: dnsServersArray.isEmpty ? nil : dnsServersArray,
                    interfaceName: interfaceName,
                    mode: mode
                )

                // Load existing config
                var config = SwiftDataHelper.loadConfig() ?? Config(profiles: [])

                // Add new profile to config
                config.profiles.append(newProfile)

                // Save updated config
                SwiftDataHelper.saveConfig(config)

                print("Profile \(newProfile.profileName) created successfully.")

                // Close the window
                appDelegate.createProfileWindow?.close()
                appDelegate.createProfileWindow = nil

                // Update the menu
                appDelegate.updateMenu()
            }
        }
        .padding()
    }
}
