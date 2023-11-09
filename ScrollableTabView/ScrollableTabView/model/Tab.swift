//
//  Tab.swift
//  ScrollableTabView
//
//  Created by 宋璞 on 2023/11/9.
//

import SwiftUI


/// Tab's
enum Tab: String, CaseIterable {
    case chats = "Chats"
    case calls = "Calls"
    case settings = "Settings"
    
    var systemImage: String {
        switch self {
        case .chats:
            return "phone"
        case .calls:
            return "bubble.left.and.bubble.right"
        case .settings:
            return "gear"
        }
    }
}
