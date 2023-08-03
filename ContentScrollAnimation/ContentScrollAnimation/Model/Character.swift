//
//  Character.swift
//  ContentScrollAnimation
//
//  Created by 宋璞 on 2023/7/28.
//

import SwiftUI

struct Character: Identifiable {
    
    var id: String = UUID().uuidString
    var value: String
    var index: Int = 0
    var rect: CGRect = .zero
    var pusOffset: CGFloat = 0
    var isCurrent: Bool = false
    var color: Color = .clear
}

