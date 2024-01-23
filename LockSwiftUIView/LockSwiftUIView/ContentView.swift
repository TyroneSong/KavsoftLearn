//
//  ContentView.swift
//  LockSwiftUIView
//
//  Created by 宋璞 on 2024/1/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        LockView(lockType: .biometric, lockPin: "0320", isEnable: true) {
            VStack(spacing: 15) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    
                Text("Hello, world!")
            }
        }
        
        
    }
}

#Preview {
    ContentView()
}
