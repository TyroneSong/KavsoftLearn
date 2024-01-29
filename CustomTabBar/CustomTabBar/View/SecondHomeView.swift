//
//  SecondHomeView.swift
//  CustomTabBar
//
//  Created by 宋璞 on 2024/1/29.
//

import SwiftUI

struct SecondHomeView: View {
    var body: some View {
        VStack {
            Text("Top")
            Spacer()
            HStack {
                Text("Bottom")
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    SecondHomeView()
}
