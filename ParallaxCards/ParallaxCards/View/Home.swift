//
//  Home.swift
//  ParallaxCards
//
//  Created by 宋璞 on 2024/2/21.
//

import SwiftUI

struct Home: View {
    // MARK: - State object of Motion Manager ⚡️
    @StateObject private var motionManager: MotionManager = .init()
    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Button {
                    
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title3)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "person")
                        .font(.title3)
                }
            }
            .foregroundStyle(.white)
            
            Text("Exclusive trips just for you")
                // MARK: - Custom Font ⚡️
                // if the font don't work, then open the font finder
                // then identify the true name
                .font(.custom("GabrielaStencilW00-Lightit", size: 25))
                .foregroundStyle(.white)
                .padding(.top, 10)
            
            ParallaxCards()
                .padding(.horizontal, -15)
            
            TabBar()
        }
        .padding(15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background {
            Rectangle()
                .fill(.BG)
                .ignoresSafeArea()
        }
    }
    
    // MARK: - Parallax Cards ⚡️
    @ViewBuilder
    private func ParallaxCards() -> some View {
        TabView(selection: $motionManager.currentSlider) {
            ForEach(sample_places) { place in
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ZStack {
                        // MARK: - Adding Parallax Effect To Current Showing Slide ⚡️
                        Image(place.bgName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .offset(
                                x: motionManager.currentSlider.id == place.id ? -motionManager.xValue * 75 : 0,
                                y: motionManager.currentSlider.id == place.id ? -motionManager.yValue * 75 : 0
                            )
                            .frame(width: size.width, height: size.height)
                            .clipped()
                        
                        Image(place.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .offset(
                                x: motionManager.currentSlider.id == place.id ? overlayOffsetX() : 0,
                                y: motionManager.currentSlider.id == place.id ? overlayOffsetY() : 0
                            )
                            .frame(width: size.width, height: size.height)
                            .clipped()
                            .scaleEffect(1.05, anchor: .bottom)
                        
                        VStack(spacing: 10) {
                            Text("FEATURES")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white.opacity(0.6))
                            
                            Text(place.placeName)
                                .font(.custom("Gabriela Stencil", size: 45))
                                .foregroundStyle(.white.opacity(0.6))
                                .shadow(color: .black.opacity(0.3), radius: 15, x: 5, y: 5)
                                .shadow(color: .black.opacity(0.3), radius: 15, x: -5, y: -5)
                            
                            Button {
                                
                            } label: {
                                Text("EXPLORE")
                                    .font(.custom("Gabriela Stencil", size: 14))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background {
                                        ZStack {
                                            Rectangle()
                                                .fill(.black.opacity(0.15))
                                            
                                            Rectangle()
                                                .fill(.white.opacity(0.3))
                                        }
                                    }
                            }
                            .padding(.top, 15)
                        }
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 60)
                        .offset(x: motionManager.currentSlider.id == place.id ? -motionManager.xValue * 15 : 0, y: motionManager.currentSlider.id == place.id ? -motionManager.yValue * 15 : 0)
                    }
                    .frame(width: size.width, height: size.height, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .animation(.interactiveSpring, value: motionManager.xValue)
                    .animation(.interactiveSpring, value: motionManager.yValue)
                    
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 40)
                .tag(place)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear(perform: motionManager.detectMotion)
        .onDisappear(perform: motionManager.stopMotionUpdates)
    }
    
    func overlayOffsetX() -> CGFloat {
        let offset = motionManager.xValue * 7
        if offset > 0 {
            return offset > 8 ? 8 : offset
        }
        return -offset > 8 ? -8 : offset
    }
    
    func overlayOffsetY() -> CGFloat {
        let offset = motionManager.yValue * 7
        if offset > 0 {
            return offset > 8 ? 8 : offset
        }
        return -offset > 8 ? -8 : offset
    }
    
    // MARK: - Tab Bar ⚡️
    @ViewBuilder
    private func TabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(["house", "suit.heart", "magnifyingglass"], id: \.self) { icon in
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    ContentView()
}
