//
//  TabBarSheetApp.swift
//  TabBarSheet
//
//  Created by 宋璞 on 2023/8/24.
//

import SwiftUI

@main
struct TabBarSheetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    var windowSharedModel = WindowSharedModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(windowSharedModel)
        }
    }
}


// MARK: - UIApplicationDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
//        config.delegateClass = SceneDelegate.self
        return config
    }
}

// MARK: - UIWindowSceneDelegate
@Observable
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    weak var windowScene: UIWindowScene?
    var tabWindow: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        windowScene = scene as? UIWindowScene
    }
    
    // 添加 Tab Bar 作为另一个 window
    func addTabBar(_ windowSharedModel: WindowSharedModel) {
        guard let scene = windowScene else {
            return
        }
        
        let tabBarController = UIHostingController(rootView:
            CustomTabBar()
            .environment(windowSharedModel)
            .frame(maxHeight: .infinity, alignment: .bottom)
        )
        tabBarController.view.backgroundColor = .clear
        // window
        let tabWindow = PassThroughWindow(windowScene: scene)
        tabWindow.rootViewController = tabBarController
        tabWindow.isHidden = false
        
        self.tabWindow = tabWindow
    }
}


class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == view ? nil : view
    }
}
