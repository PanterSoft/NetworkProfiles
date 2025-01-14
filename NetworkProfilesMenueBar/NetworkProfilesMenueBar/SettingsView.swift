//
//  SettingsView.swift
//  NetworkProfilesMenueBar
//
//  Created by Nico Mattes on 14.01.25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDockIconVisible") private var isDockIconVisible = false

    var body: some View {
        VStack {
            Toggle("Show Dock Icon", isOn: $isDockIconVisible)
                .onChange(of: isDockIconVisible) { newValue in
                    NSApp.setActivationPolicy(newValue ? .regular : .accessory)
                }
                .padding()

            Spacer()

            Button("Close") {
                NSApplication.shared.keyWindow?.close()
            }
            .padding(.top)

        }
        .frame(width: 280, height: 120)
        .padding()
    }
}
