//
//  ContentView.swift
//  NavigationHeroAnimation
//
//  Created by 宋璞 on 2023/8/17.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedProfile: Profile?
    @State private var pushView: Bool = false
    @State private var hideView: (Bool, Bool) = (false , false)
    
    var body: some View {
        NavigationStack {
            Home(selectedProFile: $selectedProfile, pushView: $pushView)
                .navigationTitle("ProFile")
                .navigationDestination(isPresented: $pushView) {
                    DetailView(
                        selectedProfile: $selectedProfile,
                        pushView: $pushView,
                        hideView: $hideView
                    )
                }
        }
        .overlayPreferenceValue(MAnchorKey.self, { value in
            GeometryReader(content: { geometry in
                if let selectedProfile, let anchor = value[selectedProfile.id], !hideView.0 {
                    let rect = geometry[anchor]
                    ImageView(profile: selectedProfile, size: rect.size)
                        .offset(x: rect.minX, y: rect.minY)
                        // Simply Animating the rect will add the geometry Effect we need
                        .animation(.snappy(duration: 0.35, extraBounce: 0), value: rect)
                }
            })
        })
    }
}

#Preview {
    ContentView()
}
