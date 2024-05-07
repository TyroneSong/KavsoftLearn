//
//  NetflixLoader.swift
//  NetflixUI
//
//  Created by 宋璞 on 2024/4/13.
//

import SwiftUI

struct NetflixLoader: View {
    
    @State private var isSpinning: Bool = false
    
    var body: some View {
        Circle()
            .stroke(.linearGradient(colors: [
                .accent,
                .accent,
                .accent,
                .accent,
                .accent.opacity(0.7),
                .accent.opacity(0.4),
                .accent.opacity(0.1),
            ], startPoint: .top, endPoint: .bottom), lineWidth: 6)
            .rotationEffect(.init(degrees: isSpinning ? 360 : 0))
            .onAppear {
                withAnimation(.linear(duration: 0.7).repeatForever(autoreverses: false)) {
                    isSpinning = true
                }
            }
    }
}

#Preview {
    NetflixLoader()
        .frame(width: 100, height: 100)
        .preferredColorScheme(.dark)
}
