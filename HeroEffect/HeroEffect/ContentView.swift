//
//  ContentView.swift
//  HeroEffect
//
//  Created by 宋璞 on 2024/2/2.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    CardView(item: item)
                }
            }
            .navigationTitle("Hero Effect")
        }

    }
}

struct CardView: View {
    var item: Item
    @State private var expandSheet: Bool = false
    var body: some View {
        HStack(spacing: 12) {
            SourceView(id: item.id.uuidString) {
                ImageView()
            }
            
            Text(item.title)
            
            Spacer(minLength: 0)
        }
        .contentShape(.rect)
        .onTapGesture {
            expandSheet.toggle()
        }
        .sheet(isPresented: $expandSheet, content: {
            DestinationView(id: item.id.uuidString) {
                ImageView()
                    .onTapGesture {
                        expandSheet.toggle()
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .padding()
            .interactiveDismissDisabled()
        })
        .heroLayer(id: item.id.uuidString, animate: $expandSheet) {
            ImageView()
        } completion: { _ in
            
        }

    }
    
    @ViewBuilder
    func ImageView() -> some View {
        Image(systemName: item.symbol)
            .font(.title2)
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(item.color.gradient, in: .circle)
    }
}

#Preview {
    ContentView()
}


struct Item: Identifiable {
    var id: UUID = .init()
    var title: String
    var color: Color
    var symbol: String
}

var items: [Item] = [
    .init(title: "Book Icon", color: .red, symbol: "book.fill"),
    .init(title: "Stack Icon", color: .blue, symbol: "square.stack.3d.up"),
    .init(title: "Rectangle Icon", color: .orange, symbol: "rectangle.portrait")
]
