//
//  Home.swift
//  ParallaxCarousel
//
//  Created by 宋璞 on 2023/8/14.
//

import SwiftUI

private let grap: CGFloat = 15

struct Home: View {
    
    // MARK: - view Properties
    @State private var searchText: String = ""
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                
                HStack(spacing: 12) {
                                        
                    Button(action: {}, label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.title)
                            .foregroundStyle(.blue)
                    })
                    
                    HStack(spacing: 12) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)

                        TextField("Search", text: $searchText)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: .capsule)
                }
                
                Text("Where do you want to \n See")
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                
                /// Parallax Carouse
                GeometryReader(content: { geometry in
                    let size = geometry.size
                    
                    ScrollView(.horizontal) {
                        HStack(spacing: 5) {
                            ForEach(tripCards) { card in
                                /// In order to Move the Card in Reverse Direction (Parallax Effect)
                                GeometryReader { proxy in
                                    let cardSize = proxy.size
                                    /// Simple Parallax Effect (1)
//                                    let minX = proxy.frame(in: .scrollView).minX - grap * 2
                                    let minX = min((proxy.frame(in: .scrollView).minX - grap * 2) * 1.4, size.width * 1.4)
                                    
                                    Image(card.image)
                                        .resizable()
                                        .scaledToFill()
                                        /// Or use Scaling
//                                        .scaleEffect(1.25)
                                        .offset(x: -minX)
                                        .frame(width: proxy.size.width * 2.5)
                                        .frame(width: cardSize.width, height: cardSize.height)
                                        .overlay{
//                                            Text("\(minX)")
//                                                .font(.largeTitle)
//                                                .foregroundStyle(.white)
                                            OverlayView(card)
                                        }
                                        .clipShape(.rect(cornerRadius: 15))
                                        .shadow(color: .black.opacity(0.25), radius: 8, x: 5, y: 10)
                                }
                                .frame(width: size.width - grap * 4, height: size.height - 50)
                                /// Scroll Animation
                                .scrollTransition(.interactive, axis: .horizontal) { view, phase in
                                    view
                                        .scaleEffect(phase.isIdentity ? 1 : 0.95)
                                }
                            }
                        }
                        .padding(.horizontal, grap * 2)
                        .scrollTargetLayout()
                        .frame(height: size.height, alignment: .top)
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                })
                .frame(height: 500)
                .padding(.horizontal, -grap)
                .padding(.top, 10)
                
            }
            .padding(15)
        }
        .scrollIndicators(.hidden)
    }
    
    
    /// Overlay View
    @ViewBuilder
    func OverlayView(_ card: TripCard) -> some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [
                .clear,
                .clear,
                .clear,
                .clear,
                .clear,
                .black.opacity(0.1),
                .black.opacity(0.5),
                .black
            ], startPoint: .top, endPoint: .bottom)
            
            VStack(alignment: .leading, spacing: 5, content: {
                Text(card.title)
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundStyle(.white)
                
                Text(card.subTitle)
                    .font(.callout)
                    .foregroundStyle(.white.opacity(0.8))
            })
            .padding(20)
        }
    }
}

#Preview {
    ContentView()
}
