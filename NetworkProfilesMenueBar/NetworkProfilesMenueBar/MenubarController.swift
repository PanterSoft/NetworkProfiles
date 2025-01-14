import Cocoa
import NetworkHelper

class MenubarController {
    static let shared = MenubarController()

    private var statusItem: NSStatusItem?
    private var profiles: [NetworkProfile] = []

    private init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "network", accessibilityDescription: "Network Profiles")
            button.action = #selector(showMenu)
        }
    }

    func loadProfiles() {
        let filePath = "/path/to/config.json" // Update with the actual path
        if let config = loadConfig(from: filePath) {
            profiles = config.profiles
        }
    }

    @objc private func showMenu() {
        let menu = NSMenu()
        for profile in profiles {
            let menuItem = NSMenuItem(title: profile.profileName, action: #selector(applyProfile(_:)), keyEquivalent: "")
            menuItem.representedObject = profile
            menu.addItem(menuItem)
        }
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "Q"))
        statusItem?.menu = menu
        statusItem?.button?.performClick(nil)
    }

    @objc private func applyProfile(_ sender: NSMenuItem) {
        if let profile = sender.representedObject as? NetworkProfile {
            applyNetworkSettings(profile: profile)
        }
    }

    @objc private func openSettings() {
        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}
