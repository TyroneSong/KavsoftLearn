//
//  CustomAnimationDemoView.swift
//  AnimatedButton
//
//  Created by 宋璞 on 2023/8/17.
//

import SwiftUI

struct CustomAnimationDemoView: View {
    @State private var isActive = false
    
    var body: some View {
        VStack(alignment: isActive ? .trailing : .leading) {
            Circle()
                .frame(width: 200)
                .foregroundColor(.accentColor)
            
            Button("Animate") {
                withAnimation(.elasticEaseInEaseOut(duration: 2.0)) {
                    isActive.toggle()
                }
            }
            .frame(width: .infinity)
        }
        .padding()
    }
}

struct ElasticEaseInEaseOutAnimation: CustomAnimation {
    
    let duration: TimeInterval
    
    func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
        if time > duration { return nil } // The animation has finished.
        
        let p = time / duration
        let s = sin((20 * p - 11.125) * ((2 * Double.pi) / 4.5))
        if p < 0.5 {
            return value.scaled(by: -(pow(2, 20 * p - 10) * s) / 2)
        } else {
            return value.scaled(by: (pow(2, -20 * p + 10) * s) / 2 + 1)
        }
    }
    
}

extension Animation {
    static var elasticEaseInEaseOut: Animation { elasticEaseInEaseOut(duration: 0.35) }
    static func elasticEaseInEaseOut(duration: TimeInterval) -> Animation {
        Animation(ElasticEaseInEaseOutAnimation(duration: duration))
    }
}

#Preview {
    CustomAnimationDemoView()
}
