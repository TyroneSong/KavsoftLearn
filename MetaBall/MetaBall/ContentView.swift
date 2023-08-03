//
//  ContentView.swift
//  MetaBall
//
//  Created by 宋璞 on 2023/7/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
