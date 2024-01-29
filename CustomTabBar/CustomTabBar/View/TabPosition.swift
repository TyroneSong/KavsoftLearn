//
//  TabPosition.swift
//  CustomTabBar
//
//  Created by 宋璞 on 2024/1/29.
//

import SwiftUI

struct PositionKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func viewPosition(completion: @escaping (CGRect) -> ()) -> some View {
        self.overlay {
            GeometryReader {
                let rect = $0.frame(in: .global)
                
                Color.clear
                    .preference(key: PositionKey.self, value: rect)
                    .onPreferenceChange(PositionKey.self, perform: completion)
            }
        }
    }
}
