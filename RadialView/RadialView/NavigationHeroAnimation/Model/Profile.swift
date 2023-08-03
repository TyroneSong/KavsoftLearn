//
//  Profile.swift
//  RadialView
//
//  Created by 宋璞 on 2023/7/26.
//

import SwiftUI


/// Sample Profile Model
struct Profile: Identifiable {
    var id = UUID().uuidString
    var userName: String
    var profilePicture: String
    var lastMsg: String
    var lastActive: String
}

extension Profile {
    
    static let files: [Profile] = [
        Profile(userName: "Name1", profilePicture: "Pic1", lastMsg: "hhhhh", lastActive: "122213"),
        Profile(userName: "Name2", profilePicture: "Pic2", lastMsg: "hhhhh", lastActive: "122213"),
        Profile(userName: "Name3", profilePicture: "Pic3", lastMsg: "hhhhh", lastActive: "122213"),
        Profile(userName: "Name4", profilePicture: "Pic4", lastMsg: "hhhhh", lastActive: "122213"),
    ]
}
