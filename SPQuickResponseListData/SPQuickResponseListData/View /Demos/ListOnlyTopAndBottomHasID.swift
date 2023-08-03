//
//  ListEachRowHasID.swift
//  SPQuickResponseListData
//
//  Created by 宋璞 on 2023/7/31.
//

import SwiftUI

struct ListOnlyTopAndBottomHasID: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>
    
    @State var showInfo: Bool = false
    
    var body: some View {
        let start = Date()
        ScrollViewReader { proxy in
            VStack {
                HStack {
                    Button("Top") {
                        withAnimation {
                            proxy.scrollTo("top", anchor: .center)
                        }
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Bottom") {
                        withAnimation {
                            proxy.scrollTo("bottom")
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                List {
                    TopCell()
                        .id("top")
                        // 隐藏两端视图的列表分割线
                        .listRowSeparator(.hidden)
                    ForEach(items) { item in
                        ItemRow(item: item)
                    }
                    BottomCell()
                        .id("bottom")
                        .listRowSeparator(.hidden)
                }
                .environment(\.defaultMinListRowHeight, 0)
            }
        }
        .navigationTitle("每行均通过 id 标识")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Info") {
                showInfo.toggle()
            }
        }
        .sheet(isPresented: $showInfo, content: { info() })
        .onAppear {
            print(Date().timeIntervalSince(Timer.demo2))
        }
        let _ = print(Date().timeIntervalSince(start))
    }
    
    
    func info() -> some View {
        let faultCount = items.filter { $0.isFault }.count
        return VStack {
            Text("Item's count: \(items.count)")
            Text("fault item's count: \(faultCount)")
        }
    }
}


struct TopCell: View {
    init() { print("Top Cell Init") }
    var body: some View {
        Text("Top")
            .frame(width: 0, height: 0)
    }
}

struct BottomCell: View {
    init() { print("Bottom Cell Init") }
    var body: some View {
        Text("Bottom")
            .frame(width: 0, height: 0)
    }
}
