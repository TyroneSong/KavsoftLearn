//
//  Profile.swift
//  NavigationHeroAnimation
//
//  Created by 宋璞 on 2023/8/17.
//

import SwiftUI

struct Profile: Identifiable {
    var id = UUID().uuidString
    var userName: String
    var profilePicture: String
    var lastMsg: String
    var lastActive: String
}


extension Profile {
    static let files: [Profile] = [
        .init(userName: "Name_1", profilePicture: "Pic1", lastMsg: "hhhh", lastActive: "23:23"),
        .init(userName: "Name_2", profilePicture: "Pic2", lastMsg: "hhhh", lastActive: "23:23"),
        .init(userName: "Name_3", profilePicture: "Pic3", lastMsg: "hhhh", lastActive: "23:23"),
        .init(userName: "Name_4", profilePicture: "Pic4", lastMsg: "hhhh", lastActive: "23:23"),
    ]
}
