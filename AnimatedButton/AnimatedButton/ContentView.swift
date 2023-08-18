//
//  ContentView.swift
//  AnimatedButton
//
//  Created by 宋璞 on 2023/8/17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CustomButton(buttonTint: .blue) {
            HStack(spacing: 10, content: {
                Text("Login")
                Image(systemName: "chevron.right")
            })
            .fontWeight(.semibold)
            .foregroundStyle(.white)
        } action: {
            try? await Task.sleep(for: .seconds(2))
            return .failed("Fail")
//            return .success
//            return .idea
        }
        .buttonStyle(.opacityLess)
        .preferredColorScheme(.dark)

    }
}


#Preview {
    ContentView()
}
