//
//  profile.swift
//  NetworkProfiles
//
//  Created by Nico Mattes on 09.01.25.
//

import Foundation
import SwiftData

@Model
public final class Profile {
    public var profile_id: UUID
    public var profile_name: String
    public var dhcp_mode: String
    public var subnet_mask: String
    public var ipv4_adress: String
    public var ipv4_router: String
    public var gateway: String
    public var dns: String
    
    public init(profile_id: UUID, profile_name: String, dhcp_mode: String, subnet_mask: String, ipv4_adress: String, ipv4_router: String, gateway: String, dns: String) {
        self.profile_id = profile_id
        self.profile_name = profile_name
        self.dhcp_mode = dhcp_mode
        self.subnet_mask = subnet_mask
        self.ipv4_adress = ipv4_adress
        self.ipv4_router = ipv4_router
        self.gateway = gateway
        self.dns = dns
    }
}

