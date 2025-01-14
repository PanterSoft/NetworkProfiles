import Foundation
import SwiftData
import AppKit

struct NetworkProfile: Codable {
    let profileName: String
    let ipv4Address: String?
    let router: String?
    let subnetMask: String?
    let dnsServers: [String]?
    let interfaceName: String
    let mode: String
}

struct Config: Codable {
    var profiles: [NetworkProfile]
}

class SwiftDataHelper {
    static func initializeModel() {
        createEmptyConfigFileIfNeeded()
    }

    static func loadConfig() -> Config? {
        do {
            let data = try Data(contentsOf: getConfigFileURL())
            let config = try JSONDecoder().decode(Config.self, from: data)
            return config
        } catch {
            showErrorPopup(message: "Failed to load config: \(error.localizedDescription)")
            return nil
        }
    }

    static func saveConfig(_ config: Config) {
        do {
            let data = try JSONEncoder().encode(config)
            try data.write(to: getConfigFileURL())
        } catch {
            showErrorPopup(message: "Failed to save config: \(error.localizedDescription)")
        }
    }

    private static func getConfigFileURL() -> URL {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0]
        return documentDirectory.appendingPathComponent("network_profiles_config.json")
    }

    private static func createEmptyConfigFileIfNeeded() {
        let fileURL = getConfigFileURL()
        let fileManager = FileManager.default
        if (!fileManager.fileExists(atPath: fileURL.path)) {
            let emptyConfig = Config(profiles: [])
            saveConfig(emptyConfig)
        }
    }

    static func applyProfileByName(config: Config, profileName: String) throws {
        if let profile = config.profiles.first(where: { $0.profileName == profileName }) {
            do {
                try applyNetworkSettings(profile: profile)
                print("Profile \(profile.profileName) applied successfully.")
            } catch {
                showErrorPopup(message: "Failed to apply profile \(profile.profileName): \(error.localizedDescription)")
            }
        } else {
            print("Profile \(profileName) not found.")
        }
    }

    static func applyNetworkSettings(profile: NetworkProfile) throws {
        var commands: [String] = []

        if profile.mode == "manual" {
            guard let ipv4Address = profile.ipv4Address, let subnetMask = profile.subnetMask, let router = profile.router else {
                print("Failed to apply profile: Missing manual configuration details.")
                return
            }
            let dnsServers = profile.dnsServers?.joined(separator: " ") ?? ""
            commands.append("networksetup -setmanual \(profile.interfaceName) \(ipv4Address) \(subnetMask) \(router)")
            if !dnsServers.isEmpty {
                commands.append("networksetup -setdnsservers \(profile.interfaceName) \(dnsServers)")
            } else {
                commands.append("networksetup -setdnsservers \(profile.interfaceName) empty")
            }
        } else if profile.mode == "dhcp" {
            commands.append("networksetup -setdhcp \(profile.interfaceName)")
            if let dnsServers = profile.dnsServers, !dnsServers.isEmpty {
                let dnsServersString = dnsServers.joined(separator: " ")
                commands.append("networksetup -setdnsservers \(profile.interfaceName) \(dnsServersString)")
            } else {
                commands.append("networksetup -setdnsservers \(profile.interfaceName) empty")
            }
        }

        for command in commands {
            let task = Process()
            task.launchPath = "/bin/bash"
            task.arguments = ["-c", command]
            let pipe = Pipe()
            task.standardError = pipe
            task.standardOutput = pipe // Protokolliere auch die Standardausgabe
            task.launch()
            task.waitUntilExit()
            let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: outputData, encoding: .utf8) ?? "Unknown output"
            if task.terminationStatus != 0 {
                throw NSError(domain: "NetworkSetupError", code: Int(task.terminationStatus), userInfo: [NSLocalizedDescriptionKey: "Unable to commit changes to network database. Error: \(output)"])
            }
        }
    }

    static func showErrorPopup(message: String) {
        let alert = NSAlert()
        alert.messageText = "Error"
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
}
