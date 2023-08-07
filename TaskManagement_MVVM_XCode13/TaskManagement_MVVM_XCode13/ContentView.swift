//
//  ContentView.swift
//  TaskManagement_MVVM_XCode13
//
//  Created by 宋璞 on 2023/8/4.
//

import SwiftUI
import CoreData

struct ContentView: View {
    

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                Home()
                    .navigationTitle("TaskManager")
                    .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            // Fallback on earlier versions
            NavigationView {
                Home()
                    .navigationTitle("TaskManager")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
