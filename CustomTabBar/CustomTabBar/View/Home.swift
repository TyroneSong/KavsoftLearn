//
//  Home.swift
//  CustomTabBar
//
//  Created by 宋璞 on 2024/1/26.
//

import SwiftUI

struct Home: View {
    
    @State private var activeTab: Tab = .home
    @Namespace private var animation
    @State private var tabShapePosition: CGPoint = .zero
    init() {
        /// Hiding Tab Bar Due To SwiftUI iOS 16 Bug
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        VStack {
            TabView(selection: $activeTab,
                    content:  {
                SecondHomeView()
                    .tag(Tab.home)
                    /// Hiddent Tab Bar
//                    .toolbar(.hidden, for: .tabBar)
                
                Text("Services")
                    .tag(Tab.services)
                    /// Hiddent Tab Bar
//                    .toolbar(.hidden, for: .tabBar)
                
                Text("Partners")
                    .tag(Tab.partners)
                    /// Hiddent Tab Bar
//                    .toolbar(.hidden, for: .tabBar)
                
                Text("Activity")
                    .tag(Tab.activity)
                    /// Hiddent Tab Bar
//                    .toolbar(.hidden, for: .tabBar)
                
            })
            
            CustomTabBar()
        }
    }
    
    /// Custom Tab Bar
    @ViewBuilder
    func CustomTabBar(_ tint: Color = Color("Blue"), _ inactiveTint: Color = .blue) -> some View {
        // Moving all the Remaining Tab Item's to Bottom
        HStack(alignment: .bottom ,spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) {
                TabItem(
                    tint: tint,
                    inactiveTint: inactiveTint,
                    tab: $0,
                    animation: animation,
                    activeTab: $activeTab,
                    position: $tabShapePosition
                )
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(content: {
            TabShape(midPoint: tabShapePosition.x)
                .fill(.white)
                .ignoresSafeArea()
                // Add Blur + shadow
                .shadow(color: tint.opacity(0.2), radius: 5, x: 0, y: -5)
                .blur(radius: 2)
                .padding(.top, 25)
        })
        // Adding Animation
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
    }
}

struct TabItem: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tab
    var animation: Namespace.ID
    @Binding var activeTab: Tab
    @Binding var position: CGPoint
    
    /// Each Tab Item Position on the Screen
    @State private var tabPosition: CGPoint = .zero
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundStyle(activeTab == tab ? .white : inactiveTint)
                .frame(width: activeTab == tab ? 58 : 35, height: activeTab == tab ? 58 : 35)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(tint.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            
            Text(tab.rawValue)
                .font(.caption)
                .foregroundStyle(activeTab == tab ? tint : .gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(.rect)
        .viewPosition(completion: { rect in
            tabPosition.x = rect.midX
            
            // Updating Avitive Tab Position
            if activeTab == tab {
                position.x = rect.midX
            }
            
        })
        .onTapGesture {
            activeTab = tab
            
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                position.x = tabPosition.x
            }
        }
    }
}

#Preview {
    ContentView()
}
