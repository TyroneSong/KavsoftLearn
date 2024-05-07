//
//  RectAnchorKey.swift
//  NetflixUI
//
//  Created by 宋璞 on 2024/4/13.
//

import SwiftUI

struct RectAnchorKey: PreferenceKey {
    
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()) { $1 }
    }
}

struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}


