//
//  ContentView.swift
//  RadioView
//
//  Created by 宋璞 on 2023/7/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Radio View")
        }
    }
}

#Preview {
    ContentView()
}
