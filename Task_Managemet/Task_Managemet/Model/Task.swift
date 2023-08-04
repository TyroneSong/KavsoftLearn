//
//  Task.swift
//  Task_Managemet
//
//  Created by 宋璞 on 2023/8/4.
//

import SwiftUI
import SwiftData

/// Change Sample To Swift Data

/// Task
@Model
class Task: Identifiable {
    var id: UUID
    var taskTitle: String
    var creationDate: Date
    var isCompleted: Bool
    var tint: String
    
    init(id: UUID = .init(), taskTitle: String, creationDate: Date = .init(), isCompleted: Bool = false, tint: String) {
        self.id = id
        self.taskTitle = taskTitle
        self.creationDate = creationDate
        self.isCompleted = isCompleted
        self.tint = tint
    }
    
    var tintColor: Color {
        switch tint {
        case "TaskColor 1": return .taskColor1
        case "TaskColor 2": return .taskColor2
        case "TaskColor 3": return .taskColor3
        case "TaskColor 4": return .taskColor4
        case "TaskColor 5": return .taskColor5
        default: return .black
        }
    }
}


//struct Task: Identifiable {
//    var id: UUID = .init()
//    var taskTitle: String
//    var creationDate: Date = .init()
//    var isCompleted: Bool = false
//    var tint: Color
//}
//var samleTasks: [Task] = [
//    .init(taskTitle: "Record Video", creationDate: .updateHour(-5), isCompleted: true, tint: .taskColor1),
//    .init(taskTitle: "Redesign Website", creationDate: .updateHour(-3), isCompleted: false, tint: .taskColor2),
//    .init(taskTitle: "Go for a Walk", creationDate: .updateHour(-4), isCompleted: false, tint: .taskColor3),
//    .init(taskTitle: "Edit video", creationDate: .updateHour(0), isCompleted: true, tint: .taskColor4),
//    .init(taskTitle: "Publish Video", creationDate: .updateHour(2), isCompleted: true, tint: .taskColor5),
//    .init(taskTitle: "Tweet about new Video", creationDate: .updateHour(1), isCompleted: false, tint: .taskColor6),
//]

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}
