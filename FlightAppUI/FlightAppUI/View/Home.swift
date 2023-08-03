//
//  Home.swift
//  FlightAppUI
//
//  Created by 宋璞 on 2023/8/2.
//

import SwiftUI

struct Home: View {
    
    // MARK: - View Bounds
    var size: CGSize
    var safeArea: EdgeInsets
    
    // MARK: - Gesture Properties
    @State var offsetY: CGFloat
    @State var currentCardIndex: CGFloat = 0
    
    // MARK: - Animation State Object
    @StateObject var animator: Animator = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .overlay(alignment: .bottomTrailing, content: {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .frame(width: 40, height: 40)
                            .background {
                                Circle()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.35), radius: 5, x: 5, y: 5)
                            }
                    }
                    .offset(x: -15, y: 15)
                    .offset(x: animator.startAnimation ? 100 : 0)

                })
                .zIndex(1)
            
            PaymentCardsView()
                .zIndex(0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .hidden()
        .background {
            ZStack(alignment: .bottom) {
                ZStack {
                    if animator.showClouds {
                        Group {
                            /// Cloud View
                            CloudView(delay: 1, size: size)
                                .offset(y: size.height * -0.1)
                            CloudView(delay: 0, size: size)
                                .offset(y: size.height * 0.3)
                            CloudView(delay: 2.5, size: size)
                                .offset(y: size.height * 0.2)
                            CloudView(delay: 2.5, size: size)
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                    
                if animator.showLoadingView {
                    BackgroundView()
                        .transition(.scale)
                        .opacity(animator.showFinalView ? 0 : 1)
                }
            }
        }
        /// 不知道为嘛，这个无效？？
        .allowsTightening(!animator.showFinalView)
        .background {
            if animator.startAnimation {
                DetailView(size: size, safeArea: safeArea)
                    .environmentObject(animator)
            }
        }
        .overlayPreferenceValue(RectKey.self) { value in
            if let anchor = value["PLANEBOUNDS"] {
                GeometryReader { proxy in
                    /// Extracing Rect From Anchor Using Geometry Reader
                    let rect = proxy[anchor]
                    let planeRect = animator.initialPlanePosition
                    let status = animator.currentPaymentStatus
                    /// Reseting Plane When it Final View Opens
                    let animationStatus = status == .finished && !animator.showFinalView
                    Image("AirPlane")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: planeRect.width, height: planeRect.height)
                        /// Flight Movemet Animation
                        .rotationEffect(.init(degrees: animationStatus ? -10 : 0))
                        .shadow(color: .black.opacity(0.25), radius: 1, x: status == .finished ? -400 : 0, y: status == .finished ? 170 : 0)
                        .offset(x: planeRect.minX, y: planeRect.minY)
                        /// Moving Plane a bit donwn To look like its center when the 3D Animation is Happen
                        .offset(y: animator.startAnimation ? 50 : 0)
                        .scaleEffect(animator.showFinalView ? 0.9 : 1)
                        .offset(y: animator.showFinalView ? 30 : 0)
                        .onAppear {
                            animator.initialPlanePosition = rect
                        }
                        .animation(.easeInOut(duration: animationStatus ? 3.5 : 1.5), value: animationStatus)
                }
            }
        }
        /// One Cloud Over Plane
        .overlay(content: {
            if animator.showClouds {
                CloudView(delay: 2.2, size: size)
                    .offset(y: -size.height * 0.25)
            }
        })
        .background {
            Color("BG")
                .ignoresSafeArea()
        }
        /// Whenever the Status Changed to Finished
        /// Toggling the Cloud View
        .onChange(of: animator.currentPaymentStatus) { newValue in
            if newValue == .finished {
                animator.showClouds = true
                
                /// Enabling Final View After Some Time
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        animator.showFinalView = true
                    }
                }
            }
        }
    }
    
    // MARK: - Top Header View
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            Image("AirLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 0.4)
                .frame(maxWidth: .infinity, alignment: .leading)

            
            HStack {
                
                FlightDetailView(alignment: .leading, place: "Los Angles", code: "LAS", timing: "23 Nov, 03:30")
                
                VStack(spacing: 8) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                    Text("4h 15m")
                }
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                
                FlightDetailView(alignment: .trailing, place: "New Yark", code: "NYX", timing: "23 Nov, 07:15")
            }
            .padding(.top, 20)
            
            // MARK: - Airplane Image View
            Image("AirPlane")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 160)
                /// Hiding the Original One
                .opacity(0)
                .anchorPreference(key: RectKey.self, value: .bounds, transform: { anchor in
                    return ["PLANEBOUNDS": anchor]
                })
                .padding(.bottom, -20)
        }
        .padding([.horizontal, .top],15)
        .padding(.top, safeArea.top)
        .background {
            Rectangle()
                .fill(.linearGradient(colors: [
                    Color("BlueTop"),
                    Color("BlueTop"),
                    Color("BlueBottom")
                ], startPoint: .top, endPoint: .bottom))
        }
        /// Applying 3D Rotation
        .rotation3DEffect(.init(degrees: animator.startAnimation ? 90 : 0), axis: (x: 1, y: 0, z: 0), anchor: .init(x: 0.5, y: 0.8))
        .offset(y: animator.startAnimation ? -100 : 0)
    }
    
    // MARK: - Caredit Cards View
    @ViewBuilder
    func PaymentCardsView() -> some View {
        VStack(spacing: 0) {
            Text("SELECT PAYMENT METHOD")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.vertical)
            
            GeometryReader { _ in

                VStack(spacing: 0) {
                    ForEach(sampleCards.indices, id: \.self) { index in
                        CardView(index: index)
                    }
                }
                .padding(.horizontal, 30)
                .offset(y: offsetY)
                .offset(y: currentCardIndex * -200.0)
                
                // MARK: - Gradient View
                Rectangle()
                    .fill(.linearGradient(colors: [
                        .clear,
                        .clear,
                        .clear,
                        .clear,
                        .white.opacity(0.3),
                        .white.opacity(0.7),
                        .white,
                    ], startPoint: .top, endPoint: .bottom))
                    .allowsTightening(false)
                
                // MARK: - Purchase Button
                Button(action: {
                    buyTicket()
                }, label: {
                    Text("Confim $1,542.00")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
                        .background {
                            Capsule()
                                .fill(Color("BlueTop").gradient)
                        }
                })
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, safeArea.bottom == 0 ? 15 : safeArea.bottom)
            
            }
            .coordinateSpace(name: "SCROLL")
        }
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged({ value in
                    offsetY = value.translation.height * 0.3
                })
                .onEnded({ value in
                    let translation = value.translation.height
                    
                    withAnimation(.easeInOut) {
                        // MARK: - Increasing/Decreasing Based on Condition
                        // 100 -> Since Card Height = 200
                        if translation > 0 && translation > 100 && currentCardIndex > 0 {
                            currentCardIndex -= 1
                        }
                        
                        if translation < 0 && -translation > 100 && currentCardIndex < CGFloat(sampleCards.count - 1) {
                            currentCardIndex += 1
                        }
                        
                        offsetY = .zero
                    }
                })
        )
        .background {
            Color.white
                .ignoresSafeArea()
        }
        .clipped()
        /// Applying 3D Rotation
        .rotation3DEffect(.init(degrees: animator.startAnimation ? -90 : 0), axis: (x: 1, y: 0, z: 0), anchor: .init(x: 0.5, y: 0.25))
        .offset(y: animator.startAnimation ? 100 : 0)
    }
    
    func buyTicket() {
        /// Animating Content
        withAnimation(.easeInOut(duration: 0.85)) {
            animator.startAnimation = true
        }
        
        /// Show Loading View After some time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.7)) {
                animator.showLoadingView = true
            }
        }
    }
    
    // MARK: - Card View
    @ViewBuilder
    func CardView(index: Int) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let progress = minY / size.height
            let constrainedProgerss = progress > 1 ? 1 : progress < 0 ? 0 : progress
            
            Image(sampleCards[index].cardImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width, height: size.height)
                // MARK: - Shadow
                .shadow(color: .black.opacity(0.8), radius: 8, x: 6, y: 6)
                // MARK: - Stacked card animation
                .rotation3DEffect(.init(degrees: constrainedProgerss * 40.0), axis: (x: 1.0, y: 0.0, z: 0.0), anchor: .bottom)
                .padding(.top, progress * -160)
                // MARK: - Moving Current Card to the Top
                .offset(y: progress < 0 ? progress * 250 : 0)
        }
        .frame(height: 200)
        .zIndex(Double(sampleCards.count - index))
        .onTapGesture {
            print(index)
        }
    }
    
    // MARK: - Background View With Ring  View
    @ViewBuilder
    func BackgroundView() -> some View {
        VStack {
           /// Payment Status
            VStack(spacing: 0) {
                ForEach(PaymentStatus.allCases, id: \.rawValue) { status in
                    Text(status.rawValue)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray.opacity(0.5))
                        .frame(height: 30)
                    
                    Image(status.symbolImage)
                }
            }
            .offset(y: animator.currentPaymentStatus == .started ? -30 : animator.currentPaymentStatus == .finished ? -60 : 0)
            .frame(height: 30, alignment: .top)
            .clipped()
            .zIndex(1)
            
            ZStack {
                /// Rings 1
                Circle()
                    .fill(Color("BG"))
                    .shadow(color: .white.opacity(0.45), radius: 5, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: -5, y: -5)
                    .scaleEffect(animator.ringAnimation[0] ? 5 : 1)
                    .opacity(animator.ringAnimation[0] ? 0 : 1)
                
                /// Rings 2
                Circle()
                    .fill(Color("BG"))
                    .shadow(color: .white.opacity(0.45), radius: 5, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: -5, y: -5)
                    .scaleEffect(animator.ringAnimation[1] ? 5 : 1)
                    .opacity(animator.ringAnimation[1] ? 0 : 1)
                
                Circle()
                    .fill(Color("BG"))
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    .scaleEffect(1.22)
                
                
                Circle()
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                
                Image(systemName: animator.currentPaymentStatus.symbolImage)
                    .font(.largeTitle)
                    .foregroundColor(.gray.opacity(0.5))
            }
            .frame(width: 80, height: 80)
            .padding(.top, 20)
            .zIndex(0)
        }
        /// Using Timer to Stimulate Loading Effect
        .onReceive(Timer.publish(every: 2.3, on: .main, in: .common).autoconnect()) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                if animator.currentPaymentStatus == .initated {
                    animator.currentPaymentStatus = .started
                } else {
                    animator.currentPaymentStatus = .finished
                }
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                animator.ringAnimation[0] = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                    animator.ringAnimation[1] = true
                }
            }
        }
        .padding(.bottom, size.height * 0.15)
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


