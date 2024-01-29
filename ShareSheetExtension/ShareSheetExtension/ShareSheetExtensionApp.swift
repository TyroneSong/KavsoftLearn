//
//  ShareSheetExtensionApp.swift
//  ShareSheetExtension
//
//  Created by 宋璞 on 2024/1/29.
//

import SwiftUI

@main
struct ShareSheetExtensionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ImageItem.self)
    }
}
