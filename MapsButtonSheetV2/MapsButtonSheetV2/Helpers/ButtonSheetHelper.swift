//
//  ButtonSheetHelper.swift
//  MapsButtonSheetV2
//
//  Created by 宋璞 on 2024/2/21.
//

import SwiftUI

extension View {
    @ViewBuilder
    /// Button Mask For Sheet
    /// - Parameter height: default 49
    func buttonMaskForSheet(mask: Bool = true, _ height: CGFloat = 49) -> some View {
        self
            .background(SheetRootViewFinder(mask: mask, height: height))
    }
}

/// Helpers
fileprivate struct SheetRootViewFinder: UIViewRepresentable {
    var mask: Bool
    var height: CGFloat
    func makeUIView(context: Context) -> UIView {
        return .init()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            if let rootView = uiView.viewBeforeWindow, let window = rootView.window {
                let safeArea = window.safeAreaInsets
                // Updating it's height So that it will create a empty sapce in the bottom
                rootView.frame = .init(
                    origin: .zero,
                    size: .init(
                        width: window.frame.width,
                        height: window.frame.height - (mask ? (height + safeArea.bottom) : 0)
                    )
                )
                
                // Hide, when Down
                rootView.clipsToBounds = true
                for view in  rootView.subviews {
                    // Removing Shadows
                    view.layer.shadowColor = UIColor.clear.cgColor
                    
                    if view.layer.animationKeys() != nil {
                        if let cornerRadiusView = view.allSubViews.first(where: { $0.layer.animationKeys()?.contains("cornerRadius") ?? false }) {
//                            print(cornerRadiusView)
                            cornerRadiusView.layer.maskedCorners = []
                        }
                    }
                }
                
            }
        }
    }
}

fileprivate extension UIView {
    var viewBeforeWindow: UIView? {
        if let superview, superview is UIWindow {
            return self
        }
        
        return superview?.viewBeforeWindow
    }
    
    /// Retreiving All Subviews form an UIView
    var allSubViews: [UIView] {
        return subviews.flatMap { [$0] + $0.subviews }
    }
}

#Preview {
    ContentView()
}
