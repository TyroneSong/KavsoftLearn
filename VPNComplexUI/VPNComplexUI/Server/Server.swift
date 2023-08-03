//
//  Server.swift
//  VPNComplexUI
//
//  Created by 宋璞 on 2023/8/3.
//

import SwiftUI

struct Server: Identifiable {
    var id = UUID().uuidString
    var name: String
    var flag: String
}

var servers = [
    Server(name: "United States", flag: "us"),
    Server(name: "India", flag: "in"),
    Server(name: "United Kingdom", flag: "uk"),
    Server(name: "France", flag: "fr"),
    Server(name: "Germany", flag: "ge"),
    Server(name: "Singapore", flag: "si"),
]
