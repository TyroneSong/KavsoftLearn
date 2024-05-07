//
//  MainView.swift
//  NetflixUI
//
//  Created by 宋璞 on 2024/4/13.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            
            // Custom  Tab bar
            CustomTabBar()
        }
        .coordinateSpace(.named("MAINVIEW"))
    }
}

#Preview {
    MainView()
        .preferredColorScheme(.dark)
}
