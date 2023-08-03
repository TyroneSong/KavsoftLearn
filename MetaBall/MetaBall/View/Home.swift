//
//  Home.swift
//  MetaBall
//
//  Created by 宋璞 on 2023/7/28.
//

import SwiftUI

struct Home: View {
    
    // MARK: - Animation Peoperties
    @State var dragOffset: CGSize = .zero
    @State var startAnimation: Bool = false
    
    @State var type: String = "Single"
    var body: some View {
        VStack {
            
            Text("Metaball Annimation")
                .font(.title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(15)
            
            Picker(selection: $type) {
                Text("Metaball")
                    .tag("Single")
                Text("Clubbed")
                    .tag("SingClubbedle")
            } label: {
            
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 15)

            if type == "Single" {
                SingleMetaBall()
            } else {
                ClubbedView()
            }
        }
    }
    
    /// Like Blob Background Animation
    @ViewBuilder
    func ClubbedView() -> some View {
        Rectangle()
            .fill(.linearGradient(colors: [Color("Gradient1"), Color("Gradient2")], startPoint: .top, endPoint: .bottom))
            .mask {
                TimelineView(.animation(minimumInterval: 3.6, paused: false)) { _ in
                    Canvas { context, size in
                        context.addFilter(.alphaThreshold(min: 0.8, color: .white))
                        
                        context.addFilter(.blur(radius: 30))
                        
                        // Drawing layer
                        context.drawLayer { ctx in
                            // Placing Symbols
                            for index in 1...15 {
                                if let resolvedView = context.resolveSymbol(id: index) {
                                    ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                                }
                            }
                        }
                    } symbols: {
                        ForEach(1...15, id: \.self) { index in
                            let offset = (startAnimation ? CGSize(width: .random(in: -180...180), height: .random(in: -240...240)) : .zero)
                            ClubbedRoundedRectangle(offset: offset)
                                .tag(index)
                        }
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                startAnimation.toggle()
            }
    }
    
    @ViewBuilder
    func ClubbedRoundedRectangle(offset: CGSize) -> some View {
        RoundedRectangle(cornerRadius: 30, style: .continuous)
            .fill(.white)
            .frame(width: 120, height: 120)
            .offset(offset)
        // MARK: - Adding Animation[Less Than TimelineView Refresh Rate]
            .animation(.easeInOut(duration: 3.6), value: offset)
    }
    
    
    /// Single MetaBall Animation
    @ViewBuilder
    func SingleMetaBall() -> some View {
        Rectangle()
            .fill(
                .linearGradient(colors: [Color("Gradient1"), Color("Gradient2")], startPoint: .top, endPoint: .bottom)
            )
            .mask {
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.8, color: .red))
                    
                    context.addFilter(.blur(radius: 40))
                    
                    // Drawing layer
                    context.drawLayer { ctx in
                        // Placing Symbols
                        for index in [1, 2] {
                            if let resolvedView = context.resolveSymbol(id: index) {
                                ctx.draw(resolvedView, at: CGPoint(x: size.width / 2, y: size.height / 2))
                            }
                        }
                    }
                } symbols: {
                    Ball()
                        .tag(1)
                    Ball(offset: dragOffset)
                        .tag(2)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        dragOffset = value.translation
                    })
                    .onEnded({ value in
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                            dragOffset = .zero
                        }
                    })
            )
        
        
    }
    
    @ViewBuilder
    func Ball(offset: CGSize = .zero) -> some View {
        Circle()
            .fill(.white)
            .frame(width: 150, height: 150)
            .offset(offset)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
