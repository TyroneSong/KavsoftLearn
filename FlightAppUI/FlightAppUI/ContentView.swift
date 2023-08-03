//
//  ContentView.swift
//  FlightAppUI
//
//  Created by 宋璞 on 2023/7/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
//        DetailView(size: size, safeArea: safeArea)
            Home(size: size, safeArea: safeArea, offsetY: .zero)
                .ignoresSafeArea( .container, edges: .vertical)
                .ignoresSafeArea( .container, edges: .vertical)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
