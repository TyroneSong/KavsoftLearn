//
//  SPQuickResponseListDataApp.swift
//  SPQuickResponseListData
//
//  Created by 宋璞 on 2023/7/31.
//

import SwiftUI

@main
struct SPQuickResponseListDataApp: App {
    
    let persistencController = PersistenceController.shared
    @State var hasDemoData = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasDemoData {
                    ContentView()
                        .environment(\.managedObjectContext, persistencController.container.viewContext)
                } else {
                    CreateDemoData()
                        .task {
                            if persistencController.itemCount() < 40000 {
                                await persistencController.emptyItem()
                                await persistencController.batchInsertItem()
                            }
                            hasDemoData = true
                        }
                }
            }
        }
    }
}

struct CreateDemoData: View {
    var body: some View {
        VStack {
            Text("创建演示数据")
            ProgressView()
        }
        .scenePadding()
    }
}
