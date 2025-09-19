//
//  AppIntent.swift
//  widget
//
//  Created by Guest User on 2025-09-15.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    @Parameter(title: "Favourite Emoji", default: "😃")
    var favoriteEmoji: String
}
