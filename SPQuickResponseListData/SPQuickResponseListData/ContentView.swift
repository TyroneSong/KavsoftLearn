//
//  ContentView.swift
//  SPQuickResponseListData
//
//  Created by 宋璞 on 2023/7/31.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("包含 40_000 条数据的列表视图", destination: ListEachRowHasID())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
