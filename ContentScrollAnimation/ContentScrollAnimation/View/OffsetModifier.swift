//
//  OffsetModifier.swift
//  ContentScrollAnimation
//
//  Created by 宋璞 on 2023/7/28.
//

import SwiftUI


extension View {
    
    @ViewBuilder
    func offset(completion: @escaping (CGRect) -> Void) -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    let rect = proxy.frame(in: .named("SCROLLER"))
                    Color.clear
                        .preference(key: OffsetKey.self, value: rect)
                        .onPreferenceChange(OffsetKey.self) { value in
                            completion(value)
                        }
                }
            }
    }
    
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
