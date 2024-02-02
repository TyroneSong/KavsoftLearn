//
//  ContentView.swift
//  MinimalTodo
//
//  Created by 宋璞 on 2024/1/31.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Todo List")
        }
    }
}

#Preview {
    ContentView()
}
