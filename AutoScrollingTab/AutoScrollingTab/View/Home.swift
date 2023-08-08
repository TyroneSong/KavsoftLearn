//
//  Home.swift
//  AutoScrollingTab
//
//  Created by 宋璞 on 2023/8/8.
//

import SwiftUI

struct Home: View {
    // MARK: - View Properties
    @State private var activeTab: Tab = .men
    @State private var scrollProgress: CGFloat = .zero
    @State private var tapState: AnimationState = .init()
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                TabIndicatorView()
                
                TabView(selection: $activeTab) {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        TabImageView(tab)
                            .tag(tab)
                            .offsetX(activeTab == tab) { rect in
                                let minX = rect.minX
                                let pageOffset = minX - (size.width * CGFloat(tab.index))
//                                print(pageOffset)
                                /// Converting Page Offset info Progress
                                let pageProgress = pageOffset / size.width
                                /// Limiting Progress
                                /// Simply Disable When the TapState value is True
                                if !tapState.status {
                                    scrollProgress = max(min(pageProgress, 0), -CGFloat(Tab.allCases.count - 1))
                                }
                            }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
    }
    
    @ViewBuilder
    func TabIndicatorView() -> some View {
        GeometryReader {
            let size = $0.size
            
            // For Display 3 item
            let tabWidth = size.width / 3
            
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Text(tab.rawValue)
                        .font(.title2.bold())
                        .foregroundColor(activeTab == tab ? .primary : .gray)
                        .frame(width: tabWidth)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                activeTab = tab
                                // Setting Scroll Progress Explicitly
                                scrollProgress = -CGFloat(tab.index)
                                tapState.startAnimation()
                            }
                        }
                       
                }
            }
            .modifier(
                AnimationEndCallBack(endValue: tapState.progress) {
//                    print("Animation Finished")
                    tapState.reset()
                }
            )
            .frame(width: CGFloat(Tab.allCases.count) * tabWidth)
            .padding(.leading, tabWidth)
            .offset(x: scrollProgress * tabWidth)
        }
        .frame(height: 50)
        .padding(.top, 15)
    }
    
    @ViewBuilder
    func TabImageView(_ tab: Tab) -> some View {
        GeometryReader {
            let size = $0.size
            
            Image(tab.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
        }
        .ignoresSafeArea(.container, edges: .bottom)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
