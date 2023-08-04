//
//  TaskRowView.swift
//  Task_Managemet
//
//  Created by 宋璞 on 2023/8/4.
//

import SwiftUI

struct TaskRowView: View {
//    @Binding var task: Task
    @Bindable var task: Task
    
    /// Model Context
    @Environment(\.modelContext) private var context
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(indicatorColor)
                .frame(width: 10, height: 10)
                .padding(4)
                .background(.white.shadow(.drop(color: .black.opacity(0.1), radius: 3)), in: .circle)
                .overlay {
                    // To make the button tap more accessible. add an invisible layer too recevive the taps
                    Circle()
                        .foregroundStyle(.clear)
                        .contentShape(Circle())
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                task.isCompleted.toggle()
                            }
                        }
                }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(task.taskTitle)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                
                Label(task.creationDate.format("hh:mm a"), systemImage: "clock")
            }
            .padding(15)
            .hSpacing(.leading)
            .background(task.tintColor, in: .rect(topLeadingRadius: 15, bottomLeadingRadius: 15))
            .strikethrough(task.isCompleted, pattern: .solid, color: .black)
            .contentShape(.contextMenuPreview, .rect(cornerRadius: 15))
            .contextMenu {
                Button("Delete Task", role: .destructive) {
                    context.delete(object: task)
                    try? context.save()
                    
                }
            }
            .offset(y: -8)
            
        }
    }
    
    var indicatorColor: Color {
        if task.isCompleted {
            return .gray
        }
        return task.creationDate.isSameHour ? .darkBlue : (task.creationDate.isPast ? .red : .black)
    }
}

#Preview {
    ContentView()
}
