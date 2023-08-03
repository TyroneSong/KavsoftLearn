//
//  TimerBackgroundApp.swift
//  TimerBackground
//
//  Created by 宋璞 on 2023/8/1.
//

import SwiftUI

@main
struct TimerBackgroundApp: App {
    @StateObject var data = TimerData()
    @Environment(\.scenePhase) var scene
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(data)
        }
        .onChange(of: scene) { newScene in
            #if !targetEnvironment(simulator)
            
            if newScene == .background {
                data.leftTimer = Date()
                print("bg")
            }
            
            if newScene == .active && data.leftTimer != nil {
                let diff = Date().timeIntervalSince(data.leftTimer)
                
                let currentTime = data.selectedTime - Int(diff)
                print(currentTime)
                
                if currentTime >= 0 {
                    withAnimation(.default) {
                        data.selectedTime = currentTime
                    }
                } else {
                    data.resetView()
                }
            }
            
            #endif
        }
    }
}
