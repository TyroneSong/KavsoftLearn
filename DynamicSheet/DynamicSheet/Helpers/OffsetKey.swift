//
//  OffsetKey.swift
//  DynamicSheet
//
//  Created by 宋璞 on 2023/8/11.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
