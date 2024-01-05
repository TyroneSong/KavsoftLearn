//
//  ContentView.swift
//  ScrollParallax
//
//  Created by 宋璞 on 2024/1/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Parallax View")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
