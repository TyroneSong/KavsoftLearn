//
//  ScreenshotPervenView.swift
//  ScreenShotHide
//
//  Created by 宋璞 on 2023/7/26.
//

import SwiftUI

struct ScreenshotPrevenView<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    /// View Properties
    @State private var hostingController: UIHostingController<Content>?
    
    var body: some View {
        _ScreenshotPrevenViewHelper(hostingController: $hostingController)
            .overlay {
                GeometryReader {
                    let size = $0.size
                    
                    Color.clear
                        .preference(key: SizeKey.self, value: size)
                        .onPreferenceChange(SizeKey.self, perform: { value in
                            if value != .zero {
                                /// Creating Hosting Controller with the size
                                if hostingController == nil {
                                    hostingController = UIHostingController(rootView: content)
                                    hostingController?.view.backgroundColor = .clear
                                    hostingController?.view.tag = 1009
                                    hostingController?.view.frame = .init(origin: .zero, size: value)
                                } else {
                                    /// Sometimes the view size may updated, In that case updating the size
                                    hostingController?.view.frame = .init(origin: .zero, size: value)
                                }
                            }
                        })
                }
            }
    }
}

fileprivate struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}


fileprivate struct _ScreenshotPrevenViewHelper<Content: View>: UIViewRepresentable {
    @Binding var hostingController: UIHostingController<Content>?
    
    func makeUIView(context: Context) -> UIView {
        let secureField = UITextField()
        secureField.isSecureTextEntry = true
        if let textLayoutView = secureField.subviews.first {
            return textLayoutView
        }
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        /// Adding hosting View as a Subview to the TextLayout View
        if let hostingController, !uiView.subviews.contains(where: { $0.tag == 1009 }) {
            // Adding Hosting Controller for one time
            uiView.addSubview(hostingController.view)
        }
    }
}


#Preview {
    ContentView()
}
