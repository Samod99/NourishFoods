//
//  widget.swift
//  widget
//
//  Created by Guest User on 2025-09-15.
//


import WidgetKit
import SwiftUI
import Foundation

struct HealthyFood {
    let name: String
    let calories: Int
    let imageName: String?
}

struct HealthyFoodWidgetEntry: TimelineEntry {
    let date: Date
    let foods: [HealthyFood]
}


struct HealthyFoodWidgetEntryView: View {
    var entry: HealthyFoodWidgetEntry
    let maxCalories: Double = 500

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.2), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 10) {
                Text("Healthy Foods")
                    .font(.headline)
                    .foregroundColor(.green)
                HStack(spacing: 12) {
                    ForEach(entry.foods.prefix(3), id: \ .name) { food in
                        VStack(spacing: 6) {
                            if let imageName = food.imageName, !imageName.isEmpty {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 48, height: 48)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .shadow(radius: 1)
                            }
                            Text(food.name)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            HStack(spacing: 2) {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                                    .font(.caption2)
                                Text("\(food.calories) cal")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            ProgressView(value: min(Double(food.calories) / maxCalories, 1.0)) {
                                Text("")
                            }
                            .progressViewStyle(LinearProgressViewStyle(tint: .green))
                            .frame(height: 6)
                        }
                        .frame(maxWidth: 80)
                    }
                }
            }
            .padding()
        }
    }
}


struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HealthyFoodProvider()) { entry in
            HealthyFoodWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Healthy Food Widget")
        .description("Shows a healthy food and its calorie data.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

// MARK: - Provider for Healthy Food Widget

struct HealthyFoodProvider: TimelineProvider {
    func placeholder(in context: Context) -> HealthyFoodWidgetEntry {
        HealthyFoodWidgetEntry(date: Date(), foods: [
            HealthyFood(name: "Fruit Salad", calories: 180, imageName: "18"),
            HealthyFood(name: "Greek Salad", calories: 320, imageName: "19"),
            HealthyFood(name: "Quinoa Bowl", calories: 420, imageName: "20")
        ])
    }

    func getSnapshot(in context: Context, completion: @escaping (HealthyFoodWidgetEntry) -> Void) {
        let entry = HealthyFoodWidgetEntry(date: Date(), foods: [
            HealthyFood(name: "Fruit Salad", calories: 180, imageName: "18"),
            HealthyFood(name: "Greek Salad", calories: 320, imageName: "19"),
            HealthyFood(name: "Quinoa Bowl", calories: 420, imageName: "20")
        ])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<HealthyFoodWidgetEntry>) -> Void) {
        let healthyFoods = [
            HealthyFood(name: "Fruit Salad", calories: 180, imageName: "18"),
            HealthyFood(name: "Greek Salad", calories: 320, imageName: "19"),
            HealthyFood(name: "Quinoa Bowl", calories: 420, imageName: "20"),
            HealthyFood(name: "Mango Juice", calories: 120, imageName: "9"),
            HealthyFood(name: "Caesar Salad", calories: 280, imageName: "17")
        ]
        // Pick 3 random foods for the widget
        let selectedFoods = healthyFoods.shuffled().prefix(3)
        let entry = HealthyFoodWidgetEntry(date: Date(), foods: Array(selectedFoods))
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}
