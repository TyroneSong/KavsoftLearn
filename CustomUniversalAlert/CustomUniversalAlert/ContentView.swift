//
//  ContentView.swift
//  CustomUniversalAlert
//
//  Created by 宋璞 on 2024/1/29.
//

import SwiftUI

struct ContentView: View {
    
    @State private var alert: AlertConfig = .init()
    @State private var alert1: AlertConfig = .init(slideEdge: .top)
    @State private var alert2: AlertConfig = .init(slideEdge: .leading)
    @State private var alert3: AlertConfig = .init(disableOutsideTap: false, slideEdge: .trailing)
    
    
    var body: some View {
        Button("Show Alert") {
            alert.present()
            alert1.present()
            alert2.present()
            alert3.present()
        }
        .alert(alertConfig: $alert) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.red.gradient)
                .frame(width: 150, height: 150)
                .onTapGesture {
                    alert.dismiss()
                }
        }
        .alert(alertConfig: $alert1) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.blue.gradient)
                .frame(width: 150, height: 150)
                .onTapGesture {
                    alert1.dismiss()
                }
        }
        .alert(alertConfig: $alert2) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.yellow.gradient)
                .frame(width: 150, height: 150)
                .onTapGesture {
                    alert2.dismiss()
                }
        }
        .alert(alertConfig: $alert3) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.green.gradient)
                .frame(width: 150, height: 150)
                .onTapGesture {
                    alert3.dismiss()
                }
        }
    }
}

#Preview {
    ContentView()
        .environment(SceneDelegate())
}
