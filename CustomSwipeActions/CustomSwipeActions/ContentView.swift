//
//  ContentView.swift
//  CustomSwipeActions
//
//  Created by 宋璞 on 2024/1/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Messages")
        }
    }
}

#Preview {
    ContentView()
}
