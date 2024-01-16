//
//  ContentView.swift
//  DropDownPicker
//
//  Created by 宋璞 on 2024/1/16.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: String?
    @State private var selection1: String?
    @State private var selection2: String?
    var body: some View {
        NavigationStack {
            VStack(spacing: 15) {
                
                Button("Click Me") {
                    
                }
                
                DropDownView(
                    hint: "Select",
                    options: [
                        "YouTube",
                        "Instagram",
                        "X(Twitter)",
                        "TikTok",
                        "Snapchat"
                    ],
                    anchor: .top,
                    selection: $selection
                )
                
                DropDownView(
                    hint: "Select",
                    options: [
                        "YouTube",
                        "Instagram",
                        "TikTok",
                        "Snapchat"
                    ],
                    anchor: .bottom,
                    selection: $selection1
                )
                
                DropDownView(
                    hint: "Select",
                    options: [
                        "YouTube",
                        "Instagram",
                        "X(Twitter)",
                        "Snapchat"
                    ],
                    anchor: .bottom,
                    selection: $selection2
                )
                
                Button("Click Me") {
                    
                }
            }
            .navigationTitle("DropDown Picker")
        }
    }
}

#Preview {
    ContentView()
}
