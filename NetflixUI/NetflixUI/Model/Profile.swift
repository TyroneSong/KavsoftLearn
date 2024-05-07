//
//  Profile.swift
//  NetflixUI
//
//  Created by 宋璞 on 2024/4/13.
//

import SwiftUI

struct Profile: Identifiable {
   
    var id: UUID = .init()
    var name: String
    var icon: String
    
    var sourceAnchorID: String {
        return id.uuidString + "SOURCE"
    }
    
    var destinationAnchorID: String {
        return id.uuidString + "DESTINATION"
    }
}

var mockProfile: [Profile] = [
    .init(name: "Bob", icon: "Bob"),
    .init(name: "Lili", icon: "Lili")
    
]


