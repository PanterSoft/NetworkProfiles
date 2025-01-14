//
//  Item.swift
//  NetworkProfilesMenueBar
//
//  Created by Nico Mattes on 14.01.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
