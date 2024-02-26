//
//  Home.swift
//  YTMiniPlayer
//
//  Created by 宋璞 on 2024/2/26.
//

import SwiftUI

struct Home: View {
    // MARK: - View Properites ⚡️
    @State private var activeTab: Tab = .home
    @State private var config: PlayerConfig = .init()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // TabView
            TabView(selection: $activeTab) {
                HomeTabView()
                    .setupTab(.home)
                
                Text(Tab.shorts.rawValue)
                    .setupTab(.shorts)
                
                Text(Tab.subcriptions.rawValue)
                    .setupTab(.subcriptions)
                
                Text(Tab.you.rawValue)
                    .setupTab(.you)
            }
            .padding(.bottom, tabBarHeight)
            
            // Mini Player View
            GeometryReader {
                let size = $0.size
                 
                if config.showMiniPlayer {
                    MiniPlayerView(size: size, config: $config) {
                        withAnimation(.easeInOut(duration: 0.3), completionCriteria: .logicallyComplete, {
                            config.showMiniPlayer = false
                        }, completion: {
                            config.resetPosition()
                            config.selectedPlayerItem = nil 
                        })
                    }
                }
            }
            
            // Custom TabBar
            CustomTabBar()
                .offset(y: config.showMiniPlayer ? tabBarHeight - (config.progress * tabBarHeight) : 0)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    /// Home Tab View
    @ViewBuilder
    func HomeTabView() -> some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 15) {
                    ForEach(items) { item in
                        PlayerItemCardView(item) {
                            config.selectedPlayerItem = item
                            withAnimation(.easeInOut(duration: 0.3)) {
                                config.showMiniPlayer = true
                            }
                        }
                    }
                }
                .padding(15)
            }
            .navigationTitle("YouTube")
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.background, for: .navigationBar)
        }
    }
    
    /// Player Item Card View
    @ViewBuilder
    func PlayerItemCardView(_ item: PlayerItem, onTap: @escaping () -> ()) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(item.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipShape(.rect(cornerRadius: 10))
                .contentShape(.rect)
                .onTapGesture(perform: onTap)
            
            HStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.callout)
                    
                    HStack(spacing: 6) {
                        Text(item.author)
                        
                        Text(". 2 Days Ago")
                    }
                    .font(.caption)
                    .foregroundStyle(.gray)
                }
            }
        }
    }
    
    /// Custom TabBar
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                VStack(spacing: 4) {
                    Image(systemName: tab.symbol)
                        .font(.title3)
                    
                    Text(tab.rawValue)
                        .font(.caption2)
                }
                .foregroundStyle(activeTab == tab ? Color.primary : .gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(.rect)
                .onTapGesture {
                    activeTab = tab
                }
            }
        }
        .frame(height: 49)
        .overlay(alignment: .top) {
            Divider()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(height: tabBarHeight)
        .background(.background)
    }
}

extension View {
    @ViewBuilder
    func setupTab(_ tab: Tab) -> some View {
        self
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
    }
    
    /// SafeArea Value
    var safeArea: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
            return safeArea
        }
        return .zero
    }
    
    var tabBarHeight: CGFloat {
        return 49 + safeArea.bottom
    }
}

#Preview {
    ContentView()
}
