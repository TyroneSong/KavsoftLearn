//
//  Home.swift
//  RadioView
//
//  Created by 宋璞 on 2023/7/25.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var colors: [ColorValue] = [.red, .yellow, .green, .purple, .pink, .orange, .brown, .cyan, .indigo, .mint].compactMap { color -> ColorValue? in
        return .init(color: color)
    }
    
    @State private var activeIndex: Int = 0
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ContentView()
}
