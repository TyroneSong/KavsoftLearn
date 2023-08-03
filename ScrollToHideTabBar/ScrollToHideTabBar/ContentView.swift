//
//  ContentView.swift
//  ScrollToHideTabBar
//
//  Created by 宋璞 on 2023/7/31.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @State private var tabState: Visibility = .visible
    
    var body: some View {
        TabView {
            NavigationStack {
                TabStateScrollView(axis: .vertical, showsIndicator: false, tabState: $tabState) {
                    VStack(spacing: 15, content: {
                        ForEach(1...6, id: \.self) { index in
                            GeometryReader(content: { geometry in
                                let size = geometry.size
                                
                                Image("pic_0\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: size.width, height: size.height)
                                    .clipShape(.rect(cornerRadius: 12))
                            })
                            .frame(height: 210)
                        }
                    })
                    .padding(15)
                }
                .navigationTitle("Home")
            }
            .tabItem {
                Image(systemName: "house")
                Text("Home")
            }
            
            // Other's
            Text("Favourites")
                .tabItem {
                    Image(systemName: "suit.heart")
                    Text("Favourites")
                }
            
            Text("Notifications")
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
            
            Text("Account")
                .tabItem {
                    Image(systemName: "person")
                    Text("Account")
                }
        }
    }
}

#Preview {
    ContentView()
}
