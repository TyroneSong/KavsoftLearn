//
//  Tab.swift
//  AutoScrollingTab
//
//  Created by 宋璞 on 2023/8/8.
//

import SwiftUI


enum Tab: String, CaseIterable {
    case men = "Men"
    case girl = "Girl"
    case machine = "Machine"
    case pretty = "Pretty"
    case worker = "Worker"
    case sun = "Sun"
    
    /// TabIndex
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
    
    /// Total Count
    var count: Int {
        return Tab.allCases.count
    }
}
