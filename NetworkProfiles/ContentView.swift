//
//  ContentView.swift
//  NetworkProfiles
//
//  Created by Nico Mattes on 09.01.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Profile]
    @State private var columnVisibility =
    NavigationSplitViewVisibility.automatic
    @State private var selectedProfile: Profile?

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(items, id: \.self, selection: $selectedProfile) { item in
                Text(item.profile_name)
            }
            .navigationTitle("Profiles")
            .toolbar {
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(action: deleteSelectedProfile) {
                        Label("Delete Item", systemImage: "trash")
                    }
                    .disabled(selectedProfile == nil)
                }
            }
        } detail: {
            if let selectedProfile = selectedProfile {
                DetailedProfileView(item: selectedProfile)
            } else {
                Text("No profile yet")
                    .font(.title)
                    .padding()
            }
        }
    }

    private func addItem() {
        withAnimation {
            let id = UUID()
            let profile_name = "Test_\(id)"
            let newProfile = Profile(profile_id: id, profile_name: profile_name, dhcp_mode: "dhcp", subnet_mask: "255.255.255.0", ipv4_adress: "192.168.0.238", ipv4_router: "192.168.0.1", gateway: "192.168.0.254", dns: "8.8.8.8")
            modelContext.insert(newProfile)
        }
    }

    private func deleteSelectedProfile() {
        if let profile = selectedProfile {
            selectedProfile = items.first
            modelContext.delete(profile)
        } else {
            selectedProfile = nil
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Profile.self, inMemory: true)
}
