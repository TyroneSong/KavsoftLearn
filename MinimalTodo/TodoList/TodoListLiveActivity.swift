//
//  TodoListLiveActivity.swift
//  TodoList
//
//  Created by 宋璞 on 2024/1/31.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TodoListAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TodoListLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TodoListAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TodoListAttributes {
    fileprivate static var preview: TodoListAttributes {
        TodoListAttributes(name: "World")
    }
}

extension TodoListAttributes.ContentState {
    fileprivate static var smiley: TodoListAttributes.ContentState {
        TodoListAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TodoListAttributes.ContentState {
         TodoListAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TodoListAttributes.preview) {
   TodoListLiveActivity()
} contentStates: {
    TodoListAttributes.ContentState.smiley
    TodoListAttributes.ContentState.starEyes
}
