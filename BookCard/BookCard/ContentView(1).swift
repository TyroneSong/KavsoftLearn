//
//  ContentView.swift
//  BookCard
//
//  Created by 宋璞 on 2024/4/17.
//

import SwiftUI

struct ContentView: View {
    @State private var progress: CGFloat = 0
    var body: some View {
        NavigationStack {
            VStack {
                OpenableBookView(config: .init(progress: progress)) { size in
                    FrontView(size)
                } insideLeft: { size in
                    LeftView()
                } insideRight: { size in
                    RightView()
                }
                
                HStack {
                    Slider(value: $progress)
                    Button("Toggle") {
                        withAnimation(.snappy(duration: 1)) {
                            progress = (progress == 1.0 ? 0.2 : 1.0)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(10)
                .background(.background, in: .rect(cornerRadius: 10))
                .padding(.top, 50)

            }
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.15))
            .navigationTitle("Book View")
        }
    }
    
    /// Front View
    @ViewBuilder
    func FrontView(_ size: CGSize) -> some View {
        Image(.book)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .offset(x: 10)
            .frame(width: size.width, height: size.height)
    }
    
    /// Left View
    @ViewBuilder
    func LeftView() -> some View {
        VStack(spacing: 5) {
            Image(.author)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(.circle)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
            
            Text("Tamara Bundy")
                .fontWidth(.condensed)
                .fontWeight(.bold)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.black)
    }
    
    /// Right View
    @ViewBuilder
    func RightView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.system(size: 14))
            
            Text("skdjks sldsjklj  sldkjflsdf safjklsdlsfkjs d sfksoif sdkfsdnsmcnvksdfsdfjskdfskhjdfksdfs dfjkslkdjfodnscnxlkjcv ")
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.black)
    }
}

struct OpenableBookView<Front: View, InsideLeft: View, InsideRight: View>: View, Animatable {
    var config: Config = .init()
    @ViewBuilder var front: (CGSize) -> Front
    @ViewBuilder var insideLeft: (CGSize) -> InsideLeft
    @ViewBuilder var insideRight: (CGSize) -> InsideRight
    
    
    var animatableData: CGFloat {
        get { config.progress }
        set { config.progress = newValue }
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            /// Limiting Progress btw 0-1
            let progress = max(min(config.progress, 1), 0)
            let rotation = progress * -180
            let cornerRadius = config.cornerRadius
            let shadowColor = config.shadowColor
            
            ZStack {
                insideRight(size)
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: cornerRadius, topTrailingRadius: cornerRadius))
                    .shadow(color: shadowColor.opacity(0.1 * progress), radius: 5, x: 5, y: 0)
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(config.dividerBackground.shadow(.inner(color: shadowColor.opacity(0.15), radius: 2)))
                            .frame(width: 6)
                            .offset(x: -3)
                            .clipped()
                    }
                
                front(size)
                    .frame(width: size.width, height: size.height)
                    /// Disabling Interaction Once it's flipped
                    .allowsHitTesting(-rotation < 90)
                    .overlay {
                        if -rotation > 90 {
                            insideLeft(size)
                                .frame(width: size.width, height: size.height)
                                .scaleEffect(x: -1)
                                .transition(.identity)
                        }
                    }
                    .clipShape(.rect(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: cornerRadius, topTrailingRadius: cornerRadius))
                    .shadow(color: shadowColor.opacity(0.15), radius: 5, x: 5, y: 0)
                    .rotation3DEffect(
                        .init(degrees: rotation),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .leading,
                        perspective: 0.3
                    )
            }
            .offset(x: (config.width / 2) * progress)
        }
        .frame(width: config.width, height: config.height)
    }
    
    struct Config {
        var width: CGFloat = 100
        var height: CGFloat = 200
        var progress: CGFloat = 0
        var cornerRadius: CGFloat = 10
        var dividerBackground: Color = .white
        var shadowColor: Color = .black
    }
}

#Preview {
    ContentView()
}
