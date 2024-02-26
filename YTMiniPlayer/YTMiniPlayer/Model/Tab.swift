//
//  Tab.swift
//  YTMiniPlayer
//
//  Created by 宋璞 on 2024/2/26.
//

import SwiftUI


enum Tab: String, CaseIterable {
    case home = "Home"
    case shorts = "Shorts"
    case subcriptions = "Subscriptions"
    case you = "You"
    
    /// Symbol Icon
    var symbol: String {
        switch self {
        case .home:
            "house.fill"
        case .shorts:
            "video.badge.waveform.fill"
        case .subcriptions:
            "play.square.stack.fill"
        case .you:
            "person.circle.fill"
        }
    }
}
