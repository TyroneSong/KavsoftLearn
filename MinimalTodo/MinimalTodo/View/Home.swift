//
//  Home.swift
//  MinimalTodo
//
//  Created by 宋璞 on 2024/1/31.
//

import SwiftUI
import SwiftData

struct Home: View {
    
    @Query(filter: #Predicate<Todo> { !$0.isCompleted }, sort: [SortDescriptor(\Todo.lastUpdated, order: .reverse)], animation: .snappy)
    private var activeList: [Todo]
    
    @Environment(\.modelContext) private var context
    @State private var showAll: Bool = false
    
    var body: some View {
        List {
            Section(activeSectionTitle) {
                ForEach(activeList) {
                    TodoRawView(todo: $0)
                }
            }
            
            CompletedTodoList(showAll: $showAll)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    // Create an Empty Todo Task
                    let todo = Todo(task: "", priority: .normal)
                    // Saving item into context
                    context.insert(todo)
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .fontWeight(.light)
                        .font(.system(size: 42))
                })
            }
        }
    }
    
    var activeSectionTitle: String {
        let count = activeList.count
        return count == 0 ? "Active" : "Active (\(count))"
    }
}

#Preview {
    ContentView()
}
