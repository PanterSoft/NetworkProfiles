//
//  NetworkProfilesMenueBarApp.swift
//  NetworkProfilesMenueBar
//
//  Created by Nico Mattes on 14.01.25.
//

import SwiftUI

@main
struct NetworkProfilesMenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView() // No default settings window
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var settingsWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set up the menu bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "network", accessibilityDescription: "Network Profiles")
            button.image?.isTemplate = true // Adapts to light/dark mode
        }
        
        // Create the menu
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))

        statusItem.menu = menu

        // Set the initial dock icon state
        setInitialDockIconState()
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

    func setInitialDockIconState() {
        let isVisible = UserDefaults.standard.bool(forKey: "isDockIconVisible")
        NSApp.setActivationPolicy(isVisible ? .regular : .accessory)
    }
}
