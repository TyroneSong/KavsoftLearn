//
//  ContentView.swift
//  NetflixUI
//
//  Created by 宋璞 on 2024/4/13.
//

import SwiftUI

struct ContentView: View {
    var appData: AppData = .init()
    var body: some View {
        ZStack {
            MainView()
            
            
            if appData.hideMainView {
                Rectangle()
                    .fill(.black)
                    .ignoresSafeArea()
            }
            
            ZStack {
                if appData.showProfileView {
                    ProfileView()
                }
            }
            .animation(.snappy, value: appData.showProfileView)
            
            if !appData.isSplashFinished {
                SplashScreen()
            }
        }
        .environment(appData)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
