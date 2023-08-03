//
//  ListEachRowHasID.swift
//  SPQuickResponseListData
//
//  Created by 宋璞 on 2023/7/31.
//

import SwiftUI

struct ListEachRowHasID: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>
    
    @State var showInfo: Bool = false
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                HStack {
                    Button("Top") {
                        withAnimation {
                            proxy.scrollTo(items.first?.objectID, anchor: .center)
                        }
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Bottom") {
                        withAnimation {
                            proxy.scrollTo(items.last?.objectID)
                        }
                    }
                    .buttonStyle(.bordered)
                }
                
                List {
                    ForEach(items) { item in
                        ItemRow(item: item)
                            .id(item.objectID)
                    }
                }
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
    }
    
    
    func info() -> some View {
        let faultCount = items.filter { $0.isFault }.count
        return VStack {
            Text("Item's count: \(items.count)")
            Text("fault item's count: \(faultCount)")
        }
    }
}

struct ListEachRowHasID_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
