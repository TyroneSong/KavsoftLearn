//
//  ShimmerEffect.swift
//  ShimmerText
//
//  Created by 宋璞 on 2023/8/9.
//

import SwiftUI

/// Custom Shimmer Effect View Modifier
extension View {
    
    @ViewBuilder
    func shimmer(_ config: ShimmerConfig) -> some View {
        self
            .modifier(ShimmerEffectHelper(config: config))
            
    }
}

/// Shimmer Effect Helper
fileprivate struct ShimmerEffectHelper: ViewModifier {
    /// Shimmer Config
    var config: ShimmerConfig
    
    // MARK: - Animation Properties
    @State private var moveTo: CGFloat = -0.7
    
    func body(content: Content) -> some View {
        content
        /// Adding Shimmer Animation with the help of Masking Modifier
        /// Hiding the Normal One and Adding Shimmer one instead
            .hidden()
            .overlay{
                Rectangle()
                    .fill(config.tint)
                    .mask {
                        content
                    }
                    .overlay {
                        /// shimmer
                        GeometryReader {
                            let size = $0.size
                            let extraOffset = size.height / 2.5
                            
                            Rectangle()
                                .fill(config.highlight)
                                .mask {
                                    Rectangle()
                                        /// Gradient For Glowing at the Center
                                        .fill(.linearGradient(colors: [
                                            .white.opacity(0),
                                            config.highlight.opacity(config.hightlightOpactity),
                                            .white.opacity(0)
                                        ], startPoint: .top, endPoint: .bottom))
                                        /// Add Blur
                                        .blur(radius: config.blur)
                                        /// Rotating (Degree)
                                        .rotationEffect(.init(degrees: -70))
                                        /// Moving To The Start
                                        .offset(x: moveTo > 0 ? extraOffset : -extraOffset)
                                        .offset(x: size.width * moveTo)
                                }
                        }
                        /// Mask With  Content
                        .mask {
                            content
                        }
                    }
                    /// Animating Movement
                    .onAppear {
                        DispatchQueue.main.async {
                            moveTo = 0.7
                        }
                    }
                    .animation(.linear(duration: config.speed).repeatForever(autoreverses: false), value: moveTo)
            }
    }
}


/// Shimmer Config
/// all the Shimmer Animation properties
struct ShimmerConfig {
    var tint: Color
    var highlight: Color
    var blur: CGFloat = 0
    var hightlightOpactity: CGFloat = 1
    var speed: CGFloat = 2
}

struct ShimmerEffect_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
