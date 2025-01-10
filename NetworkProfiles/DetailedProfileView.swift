//
//  DetailedProfileView.swift
//  NetworkProfiles
//
//  Created by Nico Mattes on 10.01.25.
//

import SwiftUI

public struct DetailedProfileView: View {
    // Declare the profile property
    private var profile: Profile

    // Initialize with a Profile item
    public init(item: Profile) {
        self.profile = item
    }

    // Body of the view
    public var body: some View {
        Text(self.profile.profile_name)
            .font(.title)
            .padding()
    }
}
