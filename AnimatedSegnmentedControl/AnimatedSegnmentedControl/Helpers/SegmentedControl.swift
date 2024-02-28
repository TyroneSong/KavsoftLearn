//
//  SegmentedControl.swift
//  AnimatedSegnmentedControl
//
//  Created by 宋璞 on 2024/2/28.
//

import SwiftUI

/// Custom View
struct SegmentedControl<Indicator: View>: View {
    var tabs: [SegmentedTab]
    @Binding var activeTab: SegmentedTab
    var height: CGFloat = 45
    // Customization Properties
    var displayAsText: Bool = false
    var font: Font = .title3
    var activeTint: Color
    var inActiveTint: Color
    /// Indicator View
    @ViewBuilder var indicatorView: (CGSize) -> Indicator
    // View Properties
    @State private var excessTabWith: CGFloat = .zero
    @State private var minX: CGFloat = .zero
    var body: some View {
        GeometryReader {
            let size = $0.size
            let containerWidhtForEachTab = size.width / CGFloat(tabs.count)
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.rawValue) { tab in
                    Group {
                        if displayAsText {
                            Text(tab.rawValue)
                        } else {
                            Image(systemName: tab.rawValue)
                        }
                    }
                    .font(font)
                    .foregroundStyle(activeTab == tab ? activeTint : inActiveTint)
                    .animation(.snappy, value: activeTab)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                    .onTapGesture {
                        
                        if let index = tabs.firstIndex(of: tab), let activeIndex = tabs.firstIndex(of: activeTab) {
                            activeTab = tab
                            
                            withAnimation(.snappy(duration: 0.25, extraBounce: 0),completionCriteria: .logicallyComplete) {
                                excessTabWith = containerWidhtForEachTab * CGFloat(index - activeIndex)
                                print(excessTabWith)
                            } completion: {
                                withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                                    minX = containerWidhtForEachTab * CGFloat(index)
                                    excessTabWith = 0
                                }
                            }
                            
                        }
                    }
                    .background(alignment: .leading) {
                        if tabs.first == tab {
                            GeometryReader {
                                let size = $0.size
                                
                                indicatorView(size)
                                    .frame(width: size.width + (excessTabWith < 0 ? -excessTabWith : excessTabWith), height: size.height)
                                    .frame(width: size.width, alignment: excessTabWith < 0 ? .trailing : .leading)
                                    .offset(x: minX)
                            }
                        }
                    }
                    
                }
            }
            .preference(key: SizeKey.self, value: size)
            .onPreferenceChange(SizeKey.self) { size in
                if let index = tabs.firstIndex(of: activeTab) {
                    minX = containerWidhtForEachTab * CGFloat(index)
                    excessTabWith = 0
                }
            }
        }
        .frame(height: height)
    }
}


fileprivate struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
    
}

#Preview {
    ContentView()
}
