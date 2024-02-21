//
//  Tab.swift
//  MapsButtonSheetV2
//
//  Created by 宋璞 on 2024/2/21.
//

import SwiftUI

/// Tabs
enum Tab: String, CaseIterable {
    case people = "People"
    case devices = "Devices"
    case items = "Items"
    case me = "Me"
    
    var symbol: String {
        switch self {
        case .people:
            "figure.2.arms.open"
        case .devices:
            "macbook.and.iphone"
        case .items:
            "circle.grid.2x2.fill"
        case .me:
            "person.circle.fill"
        }
    }
}
