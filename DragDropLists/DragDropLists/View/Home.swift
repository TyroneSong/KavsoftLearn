//
//  Home.swift
//  DragDropLists
//
//  Created by 宋璞 on 2023/7/26.
//

import SwiftUI

struct Home: View {
    @State private var todo: [Task] = [
        .init(title: "Edit Video！", status: .todo)
    ]
    @State private var working: [Task] = [
        .init(title: "Record Video！", status: .working)
    ]
    @State private var completed: [Task] = [
        .init(title: "Implement Drag & Drop", status: .completed),
        .init(title: "Update Mockview App!", status: .completed)
    ]
    

    // MARK: - View Properties
    @State private var currentlyDragging: Task?
    
    var body: some View {
        HStack(spacing: 2, content: {
            TodoView()
            
            WorkingView()
            
            CompletedView()
        })
    }
    
    /// Tasks View
    @ViewBuilder
    func TaskView(_ tasks: [Task]) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            ForEach(tasks) { task in
                GeometryReader(content: { geometry in
                    // Task Row
                    TaskRow(task, geometry.size)
                })
                .frame(height: 45)
            }
        })
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    /// Tasks Row
    @ViewBuilder
    func TaskRow(_ task: Task, _ size: CGSize) -> some View {
        Text(task.title)
            .font(.callout)
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: size.height)
            .background(.white, in: .rect(cornerRadius: 10))
            .contentShape(.dragPreview, .rect(cornerRadius: 10))
            .draggable(task.id.uuidString) {
                Text(task.title)
                    .font(.callout)
                    .padding(.horizontal, 15)
                    .frame(width: size.width, height: size.height, alignment: .leading)
                    .background(.white)
                    .contentShape(.dragPreview, .rect(cornerRadius: 10))
                    .onAppear(perform: {
                        currentlyDragging = task
                    })
            }
            .dropDestination(for: String.self) { items, location in
                currentlyDragging = nil
                return false
            } isTargeted: { status in
                if let currentlyDragging, status, currentlyDragging.id != task.id {
                    
                    appendTask(task.status)
                    
                    withAnimation(.snappy) {
                        switch task.status {
                        case .todo:
                            replaceItem(tasks: &todo, droppingTask: task, status: .todo)
                        case .working:
                            replaceItem(tasks: &working, droppingTask: task, status: .working)
                        case .completed:
                            replaceItem(tasks: &completed, droppingTask: task, status: .completed)
                        }
                    }
                }
            }

    }
    
    /// Appending And Removing task from one list to another List
    func appendTask(_ status: Status) {
        if let currentlyDragging {
            switch status {
            case .todo:
                // Safe Check and Inseting into list
                if !todo.contains(where: { $0.id == currentlyDragging.id }) {
                    // Updating it's status
                    var updatedTask = currentlyDragging
                    updatedTask.status = .todo
                    // Adding to the list
                    todo.append(updatedTask)
                    // Removing it from other Lists
                    working.removeAll(where: { $0.id == currentlyDragging.id })
                    completed.removeAll(where: { $0.id == currentlyDragging.id })
                }
            case .working:
                // Safe Check and Inseting into list
                if !working.contains(where: { $0.id == currentlyDragging.id }) {
                    // Updating it's status
                    var updatedTask = currentlyDragging
                    updatedTask.status = .working
                    // Adding to the list
                    working.append(updatedTask)
                    // Removing it from other Lists
                    todo.removeAll(where: { $0.id == currentlyDragging.id })
                    completed.removeAll(where: { $0.id == currentlyDragging.id })
                }
            case .completed:
                // Safe Check and Inseting into list
                if !completed.contains(where: { $0.id == currentlyDragging.id }) {
                    // Updating it's status
                    var updatedTask = currentlyDragging
                    updatedTask.status = .completed
                    // Adding to the list
                    completed.append(updatedTask)
                    // Removing it from other Lists
                    working.removeAll(where: { $0.id == currentlyDragging.id })
                    todo.removeAll(where: { $0.id == currentlyDragging.id })
                }
            }
        }
    }
    
    /// Replaceing Items within the list
    func replaceItem(tasks: inout [Task], droppingTask: Task, status: Status) {
        if let currentlyDragging {
            if let sourceIndex = tasks.firstIndex(where: { $0.id == currentlyDragging.id }),
               let destinationIndex = tasks.firstIndex(where: { $0.id == droppingTask.id }) {
                // Swapping Item's on the list
                var sourceItem = tasks.remove(at: sourceIndex)
                sourceItem.status = status
                tasks.insert(sourceItem, at: destinationIndex)
            }
        }
    }
    
    
    /// Todo View
    @ViewBuilder
    func TodoView() -> some View {
        NavigationStack {
            ScrollView(.vertical) {
                TaskView(todo)
            }
            .navigationTitle("Todo")
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .contentShape(.rect)
            .dropDestination(for: String.self) { items, location in
                // Appending to the last of the current list, if the item is not present on that list
                withAnimation(.snappy) {
                    appendTask(.todo)
                }
                return true
            } isTargeted: { _ in
                
            }
        }
    }
    
    /// Working View
    @ViewBuilder
    func WorkingView() -> some View {
        NavigationStack {
            ScrollView(.vertical) {
                TaskView(working)
            }
            .navigationTitle("Working")
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .contentShape(.rect)
            .dropDestination(for: String.self) { items, location in
                withAnimation(.snappy) {
                    appendTask(.working)
                }
                return true
            } isTargeted: { _ in
                
            }
            
        }
    }
    
    /// Completed View
    @ViewBuilder
    func CompletedView() -> some View {
        NavigationStack {
            ScrollView(.vertical) {
                TaskView(completed)
            }
            .navigationTitle("Completed")
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .contentShape(.rect)
            .dropDestination(for: String.self) { items, location in
                withAnimation(.snappy) {
                    appendTask(.completed)
                }
                return true
            } isTargeted: { _ in
                
            }
        }
    }
}

#Preview {
    ContentView()
}
