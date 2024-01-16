//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by 宋璞 on 2024/1/5.
//

import SwiftUI

struct ContentView: View {
    
    /// Intro
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    /// Active Tab
    @State private var activeTab: Tab = .recents
    
    
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesBackground") private var lockWhenAppGoesBackground: Bool = false
    
    var body: some View {
        TabView(selection: $activeTab) {
            
            Recents()
                .tag(Tab.recents)
                .tabItem { Tab.recents.tabContent }
            
            Search()
                .tag(Tab.search)
                .tabItem { Tab.search.tabContent }
            
            Grapha()
                .tag(Tab.charts)
                .tabItem { Tab.charts.tabContent }
            
            Settings()
                .tag(Tab.settings)
                .tabItem { Tab.settings.tabContent }
        }
        .tint(appTint)
        .sheet(isPresented: $isFirstTime, content: {
            IntroScreen()
                .interactiveDismissDisabled()
        })
    }
}

#Preview {
    ContentView()
}
