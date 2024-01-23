//
//  ContentView.swift
//  DockProgressView
//
//  Created by 宋璞 on 2024/1/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var dockProgress: DockProgress = .shared
    
    var body: some View {
        VStack(spacing: 12) {
            Picker("Style", selection: $dockProgress.type) {
                ForEach(DockProgress.ProgressType.allCases, id: \.self) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
            
            Toggle("Show Dock Progress", isOn: $dockProgress.isVisible)
        }
        .padding(15)
        .frame(width: 200, height: 200)
        .onReceive(Timer.publish(every: 0.1, on: .main, in: .common).autoconnect(), perform: { _ in
            if dockProgress.isVisible {
                if dockProgress.progress >= 1.0 {
                    dockProgress.isVisible = false
                    dockProgress.progress = .zero
                } else {
                    dockProgress.progress += 0.007
                }
            }
        })
    }
}

#Preview {
    ContentView()
}
