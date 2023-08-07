//
//  TaskManagement_MVVM_XCode13App.swift
//  TaskManagement_MVVM_XCode13
//
//  Created by 宋璞 on 2023/8/4.
//

import SwiftUI

@main
struct TaskManagement_MVVM_XCode13App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
