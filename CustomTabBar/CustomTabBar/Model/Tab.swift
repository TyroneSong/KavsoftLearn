//
//  Tab.swift
//  CustomTabBar
//
//  Created by 宋璞 on 2024/1/26.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case services = "Services"
    case partners = "Partners"
    case activity = "Activity"
    
    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .services:
            return "envelope.open.badge.clock"
        case .partners:
            return "hand.raised"
        case .activity:
            return "bell"
        }
    }
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}
