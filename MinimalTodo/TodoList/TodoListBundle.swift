//
//  TodoListBundle.swift
//  TodoList
//
//  Created by 宋璞 on 2024/1/31.
//

import WidgetKit
import SwiftUI

@main
struct TodoListBundle: WidgetBundle {
    var body: some Widget {
        TodoList()
        TodoListLiveActivity()
    }
}
