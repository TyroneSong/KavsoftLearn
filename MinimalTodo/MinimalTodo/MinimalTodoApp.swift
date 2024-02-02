//
//  MinimalTodoApp.swift
//  MinimalTodo
//
//  Created by 宋璞 on 2024/1/31.
//

import SwiftUI

@main
struct MinimalTodoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Todo.self])
    }
}
