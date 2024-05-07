//
//  ContentView.swift
//  CustomTransition
//
//  Created by 宋璞 on 2024/4/17.
//

import SwiftUI

struct ContentView: View {
    @State private var showView: Bool = false
    var body: some View {
        NavigationStack {
            
            VStack {
                ZStack {
                    if showView {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.black.gradient)
                            .transition(.reFlip)
                        
                    } else {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(.red.gradient)
                            .transition(.flip)
                    }
                }
                .frame(width: 200, height: 300)
                
                Button(showView ? "Hide" : "Reveal") {
                    withAnimation(.bouncy(duration: 1)) {
                        showView.toggle()
                    }
                }
                .padding(.top, 30)
            }
            .navigationTitle("Custom Transtion")
        }
    }
}

#Preview {
    ContentView()
}

struct FlipTranstion: ViewModifier, Animatable {
    var progress: CGFloat = 0
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    /// 多转几圈。。失败
    var circle: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .opacity(progress < 0 ? (-progress < 0.5 ? 1 : 0) : (progress < 0.5 ? 1 : 0))
            .rotation3DEffect(
                .init(degrees: (progress * 180 + circle * 360)),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
    }
}

extension AnyTransition {
    static let flip: AnyTransition = .modifier(
        active: FlipTranstion(progress: -1, circle: 0),
        identity: FlipTranstion()
    )
    
    static let reFlip: AnyTransition = .modifier(
        active: FlipTranstion(progress: 1, circle: 0),
        identity: FlipTranstion()
    )
}
