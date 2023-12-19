//
//  ContentView.swift
//  CustomToasts
//
//  Created by 宋璞 on 2023/12/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Toast") {
                Toast.shared.present(
                    title: "Hello",
                    symbol: "globe",
                    isUserInteractionEnabled: true,
                    timing: .medium
                )
            }
        }
        .padding()
    }
}

#Preview {
    RootView {
        ContentView()
    }
}
