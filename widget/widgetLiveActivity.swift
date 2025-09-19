//
//  widgetLiveActivity.swift
//  widget
//
//  Created by Guest User on 2025-09-15.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct widgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties
        var emoji: String
    }

    // Fixed non-changing properties
    var name: String
}

struct widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: widgetAttributes.self) { context in
            // Lock screen/banner
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
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

extension widgetAttributes {
    fileprivate static var preview: widgetAttributes {
        widgetAttributes(name: "World")
    }
}

extension widgetAttributes.ContentState {
    fileprivate static var smiley: widgetAttributes.ContentState {
        widgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: widgetAttributes.ContentState {
         widgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: widgetAttributes.preview) {
   widgetLiveActivity()
} contentStates: {
    widgetAttributes.ContentState.smiley
    widgetAttributes.ContentState.starEyes
}
