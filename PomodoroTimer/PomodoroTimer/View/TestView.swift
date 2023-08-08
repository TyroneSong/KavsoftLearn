//
//  TestView.swift
//  PomodoroTimer
//
//  Created by 宋璞 on 2023/8/8.
//

import SwiftUI

struct TestView: View {
    
    @State var items: [Item] = [
            Item(user: "Daniel", active: false),
            Item(user: "Jack", active: true),
            Item(user: "John", active: true)
        ]
    
    var body: some View {
        List {
//            ForEach(items) { item in
//                if item.active {
//                    listItem(for: item)
//                } else {
//                    listItem(for: item)
//                }
//                
//            }
            
            Text("Options")
                .contextMenu {
                    Button {
                        print("llll")
                    } label: {
                        Label("Choo", systemImage: "globe")
                    }

                    Button {
                        print("Enable geolocation")
                    } label: {
                        Label("Detect Location", systemImage: "location.circle")
                    }
                }
        }
    }
    
    
    @ViewBuilder
    private func listItem(for item: Item) -> some View {
            VStack {
                Text("\(item.user)")

                HStack {
                    Text("Active ? ")
                    Text(item.active ? "YES": "NO")
                }
            }
            .contextMenu {
                Button(item.active ? "Deactivate" : "Activate") {
                    if let index = items.firstIndex(where: { $0.id == item.id }) {
                        items[index].active.toggle()
                    }
                }
            }
            .id(item.id)
        }
}


struct Item: Identifiable {
    let id = UUID()
    let user: String
    var active: Bool
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
