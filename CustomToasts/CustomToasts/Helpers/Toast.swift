//
//  Toast.swift
//  CustomToasts
//
//  Created by 宋璞 on 2023/12/18.
//

import SwiftUI

struct RootView<Content: View>: View {
    @ViewBuilder var content: Content
    // MARK: - View Properties ⚡️
    @State private var overlayWindow: UIWindow?
    var body: some View {
        content
            .onAppear {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, overlayWindow == nil {
                    let window = PassthroughWindow(windowScene: windowScene)
                    window.backgroundColor = .clear
                    /// View Controller
                     let rootController = UIHostingController(rootView: ToastGroup())
                    rootController.view.frame = windowScene.keyWindow?.frame ?? .zero
                    rootController.view.backgroundColor = .clear
                    window.rootViewController = rootController
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    window.tag = 1009
                    
                    overlayWindow = window
                }
            }
    }
}

/// In order to make the root view controllerinteractable, we need to convert the overlaywindow into a pass-through window,which passes all the interactions to theroot view controller.
/// 为了使根视图控制器可交互，我们需要将覆盖窗口转换为传递窗口，它将所有的交互传递给根视图控制器。
fileprivate class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == view ? nil : view
    }
}

//@Observable
//class Toast {
//    /// 因为这个类符合Observableprotocol，我们可以使用这个单例对象作为状态对象来接收覆盖窗口根控制器上的Ul更新。
//    static let shared = Toast()
//    fileprivate var toasts: [ToastItem] = []
//    
//    func present(title: String, symbol: String?, tint: Color = .primary, isUserInteractionEnabled: Bool = false, timing: ToastTime = .medium) {
//        withAnimation(.snappy) {
//            toasts.append(.init(title: title, symbol: symbol, tint: tint, isUserInteractionEnabled: isUserInteractionEnabled, timing: timing))
//        }
//    }
//}


class Toast: ObservableObject {
    /// 因为这个类符合Observableprotocol，我们可以使用这个单例对象作为状态对象来接收覆盖窗口根控制器上的Ul更新。
    static let shared = Toast()
    @Published fileprivate var toasts: [ToastItem] = []
    @Published var count = 0
    
    func present(title: String, symbol: String?, tint: Color = .primary, isUserInteractionEnabled: Bool = false, timing: ToastTime = .medium) {
        
        count += 1
        print("\(count)")
        withAnimation(.snappy) {
            toasts.append(.init(title: title, symbol: symbol, tint: tint, isUserInteractionEnabled: isUserInteractionEnabled, timing: timing))
        }
    }
}

struct ToastItem: Identifiable {
    var id: UUID = .init()
    // MARK: - 通用属性 ⚡️
    var title: String
    var symbol: String?
    var tint: Color
    var isUserInteractionEnabled: Bool
    /// Timing
    var timing: ToastTime = .medium
}

enum ToastTime: CGFloat {
    case short = 1.0
    case medium = 2.0
    case long = 3.5
}

fileprivate struct ToastGroup: View {
    @State var model = Toast.shared
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                Text("\(model.count)")
                    .offset(y: -200)
                ForEach(model.toasts) { toast in
                    ToastView(size: size, item: toast)
                        .scaleEffect(scale(toast))
                        .offset(y: offsetY(toast))
                        .zIndex(Double(model.toasts.firstIndex(where: { $0.id == toast.id }) ?? 0))
                }
            }
            .padding(.bottom, safeArea.top == .zero ? 15 : 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    func offsetY(_ item: ToastItem) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(model.toasts.count) - 1
        return (totalCount - index) >= 2 ? -20 : ((totalCount - index) * -10)
    }
    
    func scale(_ item: ToastItem) -> CGFloat {
        let index = CGFloat(model.toasts.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(model.toasts.count) - 1
        return 1 - ((totalCount - index) >= 2 ? 0.2 : ((totalCount - index) * 0.1))
    }
}

fileprivate struct ToastView: View {
    var size: CGSize
    var item: ToastItem
    
//    @State private var animateIn: Bool = false
//    @State private var animateOut: Bool = false
    @State private var delayTask: DispatchWorkItem?
    var body: some View {
        HStack(spacing: 0) {
            if let symbol = item.symbol {
                Image(systemName: symbol)
                    .font(.title3)
                    .padding(.trailing, 10)
            }
            
            Text(item.title)
        }
        .foregroundStyle(item.tint)
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(
            .background
                .shadow(.drop(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5))
                .shadow(.drop(color: .primary.opacity(0.06), radius: 8, x: -5, y: -5)),
            in: .capsule
        )
        .contentShape(.capsule)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded({ value in
                    guard item.isUserInteractionEnabled else { return }
                    let endY = value.translation.height
                    let velocityY = value.velocity.height
                    
                    if (endY + velocityY) > 100 {
                        removeToast()
                    }
                })
        )
//        .offset(y: animateIn ? 0 : 150)
//        .offset(y: !animateOut ? 0 : 150)
//        .task {
////            guard !animateIn else { return }
////            withAnimation(.snappy) {
////                animateIn = true
////            }
//            
//            try? await Task.sleep(for: .seconds(item.timing.rawValue))
//            
//            removeToast()
//        }
        .onAppear {
            guard delayTask == nil else { return }
            delayTask = .init(block: {
                removeToast()
            })
            
            if let delayTask {
                DispatchQueue.main.asyncAfter(deadline: .now() + item.timing.rawValue, execute: delayTask)
            }
        }
        .frame(maxWidth: size.width * 0.7)
        .transition(.offset(y: 150))
        
    }
    
    func removeToast() {
//        guard !animateOut else { return }
//        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
//            animateOut = true
//        } completion: {
//            removeToastItem()
//        }
        if let delayTask {
            delayTask.cancel()
        }
        withAnimation(.snappy) {
            Toast.shared.toasts.removeAll(where: { $0.id == item.id })
        }

    }
    
//    func removeToastItem() {
//        Toast.shared.toasts.removeAll(where: { $0.id == item.id })
//    }
}

#Preview(body: {
    RootView {
        ContentView()
    }
})
