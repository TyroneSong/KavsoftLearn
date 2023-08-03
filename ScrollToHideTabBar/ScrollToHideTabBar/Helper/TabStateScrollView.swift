//
//  TabStateScrollView.swift
//  ScrollToHideTabBar
//
//  Created by 宋璞 on 2023/7/31.
//

import SwiftUI

/// Custom View
struct TabStateScrollView<Content: View>: View {
    
    var axis: Axis.Set
    var showsIndicator: Bool
    @Binding var tabState: Visibility
    var content: Content
    init(axis: Axis.Set, showsIndicator: Bool, tabState: Binding<Visibility>, @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.showsIndicator = showsIndicator
        self._tabState = tabState
        self.content = content()
    }
    
    var body: some View {
        // supports iOS 16 & iOS 17
        if #available(iOS 17, *) {
            ScrollView(axis) {
                content
            }
            .scrollIndicators(showsIndicator ? .visible : .hidden)
        } else {
            ScrollView(axis, showsIndicators: showsIndicator, content: {
                content
            })
        }
    }
}

// 添加一个通用手势，来识别滑动方向
fileprivate struct CustomGesture: UIViewRepresentable {
    var onChange: (UIPanGestureRecognizer) -> Void
    private let gestureID = UUID().uuidString
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let superView = uiView.superview?.superview,
                !(superView.gestureRecognizers?.contains(where: { $0.name == gestureID }) ?? false) {
                
            }
        }
    }
}

#Preview {
    ContentView()
}
