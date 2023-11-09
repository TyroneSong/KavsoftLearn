//
//  View+Extensions.swift
//  ScrollableTabView
//
//  Created by 宋璞 on 2023/11/9.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                    
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            }
    }
    
    /// Tab Bar Masking
    @ViewBuilder
    func tabMask(_ tabProgress: CGFloat) -> some View {
        ZStack {
            self
                .foregroundStyle(.gray)
            
            self
                .symbolVariant(.fill)
                .mask {
                    GeometryReader {
                        let size = $0.size
                        let capsuleWith = size.width / CGFloat(Tab.allCases.count)
                        
                        Capsule()
                            .frame(width: capsuleWith)
                            .offset(x: tabProgress * (size.width - capsuleWith))
                    }
                }
        }
    }
}


#Preview(body: {
    ContentView()
})
