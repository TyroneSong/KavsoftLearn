//
//  Task.swift
//  DragDropLists
//
//  Created by 宋璞 on 2023/7/26.
//

import SwiftUI

struct Task: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var status: Status
}


enum Status {
    case todo
    case working
    case completed
}
