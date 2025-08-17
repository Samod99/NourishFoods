import Foundation
import SwiftUI

// MARK: - Health Profile Model
struct HealthProfile: Codable {
    let userId: String
    var age: Int
    var weight: Double // in kg
    var height: Double // in cm
    var gender: Gender
    var activityLevel: ActivityLevel
    var goal: HealthGoal
    var dietaryRestrictions: [DietaryRestriction]
    var allergies: [String]
    
    enum Gender: String, CaseIterable, Codable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
    }
    
    enum ActivityLevel: String, CaseIterable, Codable {
        case sedentary = "Sedentary"
        case lightlyActive = "Lightly Active"
        case moderatelyActive = "Moderately Active"
        case veryActive = "Very Active"
        case extremelyActive = "Extremely Active"
        
        var multiplier: Double {
            switch self {
            case .sedentary: return 1.2
            case .lightlyActive: return 1.375
            case .moderatelyActive: return 1.55
            case .veryActive: return 1.725
            case .extremelyActive: return 1.9
            }
        }
    }
    
    enum HealthGoal: String, CaseIterable, Codable {
        case loseWeight = "Lose Weight"
        case maintainWeight = "Maintain Weight"
        case gainWeight = "Gain Weight"
        case buildMuscle = "Build Muscle"
    }
    
    enum DietaryRestriction: String, CaseIterable, Codable {
        case vegetarian = "Vegetarian"
        case vegan = "Vegan"
        case glutenFree = "Gluten-Free"
        case dairyFree = "Dairy-Free"
        case lowCarb = "Low-Carb"
        case lowFat = "Low-Fat"
        case keto = "Keto"
        case paleo = "Paleo"
    }
    
    // Calculate daily calorie needs using Harris-Benedict equation
    var dailyCalorieNeeds: Int {
        let bmr: Double
        
        if gender == .male {
            bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * Double(age))
        } else {
            bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * Double(age))
        }
        
        let tdee = bmr * activityLevel.multiplier
        
        switch goal {
        case .loseWeight:
            return Int(tdee - 500) // 500 calorie deficit
        case .maintainWeight:
            return Int(tdee)
        case .gainWeight, .buildMuscle:
            return Int(tdee + 300) // 300 calorie surplus
        }
    }
    
    // Calculate BMI
    var bmi: Double {
        let heightInMeters = height / 100
        return weight / (heightInMeters * heightInMeters)
    }
    
    var bmiCategory: String {
        switch bmi {
        case ..<18.5:
            return "Underweight"
        case 18.5..<25:
            return "Normal"
        case 25..<30:
            return "Overweight"
        default:
            return "Obese"
        }
    }
}

// MARK: - Daily Calorie Tracking
struct DailyCalorieEntry: Codable, Identifiable {
    let id = UUID()
    let date: Date
    let foodProduct: FoodProduct
    let quantity: Int
    let mealType: MealType
    let timestamp: Date
    
    enum MealType: String, CaseIterable, Codable {
        case breakfast = "Breakfast"
        case lunch = "Lunch"
        case dinner = "Dinner"
        case snack = "Snack"
        
        var icon: String {
            switch self {
            case .breakfast: return "🌅"
            case .lunch: return "☀️"
            case .dinner: return "🌙"
            case .snack: return "🍎"
            }
        }
    }
    
    var totalCalories: Int {
        return foodProduct.calories * quantity
    }
}

// MARK: - AI Health Recommendation System
class HealthAI: ObservableObject {
    @Published var healthProfile: HealthProfile?
    @Published var dailyEntries: [DailyCalorieEntry] = []
    @Published var recommendations: [HealthRecommendation] = []
    @Published var calorieAlert: CalorieAlert?
    
    private let healthyFoodCategories: [FoodProduct.ProductType] = [
        .salads, .fruits, .juices, .vegetarian, .seafood
    ]
    
    private let unhealthyFoodCategories: [FoodProduct.ProductType] = [
        .fastFood, .desserts, .snacks
    ]
    
    // MARK: - Calorie Tracking
    func addFoodEntry(_ product: FoodProduct, quantity: Int, mealType: DailyCalorieEntry.MealType) {
        let entry = DailyCalorieEntry(
            date: Date(),
            foodProduct: product,
            quantity: quantity,
            mealType: mealType,
            timestamp: Date()
        )
        dailyEntries.append(entry)
        
        analyzeCalorieIntake()
        generateRecommendations()
    }
    
    func getTodayCalories() -> Int {
        let today = Calendar.current.startOfDay(for: Date())
        return dailyEntries
            .filter { Calendar.current.isDate($0.date, inSameDayAs: today) }
            .reduce(0) { $0 + $1.totalCalories }
    }
    
    func getWeeklyCalories() -> [Int] {
        let calendar = Calendar.current
        let today = Date()
        var weeklyCalories: [Int] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let dayStart = calendar.startOfDay(for: date)
                let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
                
                let dayCalories = dailyEntries
                    .filter { $0.timestamp >= dayStart && $0.timestamp < dayEnd }
                    .reduce(0) { $0 + $1.totalCalories }
                
                weeklyCalories.append(dayCalories)
            }
        }
        
        return weeklyCalories.reversed()
    }
    
    // MARK: - AI Analysis
     func analyzeCalorieIntake() {
        guard let profile = healthProfile else { return }
        
        let todayCalories = getTodayCalories()
        let dailyLimit = profile.dailyCalorieNeeds
        
        // Check if user is exceeding daily calorie limit
        if todayCalories > dailyLimit {
            let excess = todayCalories - dailyLimit
            calorieAlert = CalorieAlert(
                type: .exceeded,
                message: "You've exceeded your daily calorie limit by \(excess) calories",
                excessCalories: excess,
                recommendations: generateHealthyAlternatives()
            )
        } else if todayCalories > Int(Double(dailyLimit) * 0.8) {
            // Warning when approaching limit (80% of daily limit)
            calorieAlert = CalorieAlert(
                type: .warning,
                message: "You're approaching your daily calorie limit",
                excessCalories: 0,
                recommendations: generateHealthyAlternatives()
            )
        } else {
            calorieAlert = nil
        }
    }
    
     func generateRecommendations() {
        guard let profile = healthProfile else { return }
        
        recommendations.removeAll()
        
        // Analyze eating patterns
        let recentEntries = dailyEntries.suffix(10)
        let unhealthyCount = recentEntries.filter { unhealthyFoodCategories.contains($0.foodProduct.productType) }.count
        let healthyCount = recentEntries.filter { healthyFoodCategories.contains($0.foodProduct.productType) }.count
        
        // Generate personalized recommendations
        if unhealthyCount > healthyCount {
            recommendations.append(HealthRecommendation(
                type: .dietary,
                title: "Increase Healthy Food Intake",
                message: "Try to include more salads, fruits, and vegetables in your diet",
                priority: .high,
                category: .nutrition
            ))
        }
        
        if getTodayCalories() > profile.dailyCalorieNeeds {
            recommendations.append(HealthRecommendation(
                type: .calorie,
                title: "Calorie Management",
                message: "Consider lighter meal options to stay within your daily calorie goal",
                priority: .high,
                category: .weight
            ))
        }
        
        // Add general health recommendations
        recommendations.append(HealthRecommendation(
            type: .general,
            title: "Stay Hydrated",
            message: "Drink plenty of water throughout the day",
            priority: .medium,
            category: .hydration
        ))
    }
    
    private func generateHealthyAlternatives() -> [FoodProduct] {
        // This would typically connect to your food database
        // For now, return sample healthy alternatives
        return SampleData.sampleFoodProducts.filter { product in
            healthyFoodCategories.contains(product.productType) &&
            product.calories < 400 // Low calorie options
        }.prefix(5).map { $0 }
    }
    
    // MARK: - AI-Powered Insights
    func getHealthInsights() -> [HealthInsight] {
        var insights: [HealthInsight] = []
        
        let todayCalories = getTodayCalories()
        let weeklyCalories = getWeeklyCalories()
        
        // Calorie trend analysis
        if weeklyCalories.count >= 3 {
            let recentAverage = Array(weeklyCalories.suffix(3)).reduce(0, +) / 3
            let earlierAverage = Array(weeklyCalories.prefix(3)).reduce(0, +) / 3
            
            if recentAverage > earlierAverage * Int(1.2) {
                insights.append(HealthInsight(
                    type: .trend,
                    title: "Calorie Intake Increasing",
                    message: "Your daily calorie intake has increased by 20% this week",
                    severity: .warning
                ))
            }
        }
        
        // Meal timing analysis
        let mealEntries = dailyEntries.filter { Calendar.current.isDateInToday($0.timestamp) }
        let lateNightMeals = mealEntries.filter { 
            let hour = Calendar.current.component(.hour, from: $0.timestamp)
            return hour >= 22 || hour <= 4
        }
        
        if !lateNightMeals.isEmpty {
            insights.append(HealthInsight(
                type: .timing,
                title: "Late Night Eating",
                message: "Consider avoiding late night meals for better digestion",
                severity: .info
            ))
        }
        
        return insights
    }
}

// MARK: - Supporting Models
struct HealthRecommendation: Identifiable {
    let id = UUID()
    let type: RecommendationType
    let title: String
    let message: String
    let priority: Priority
    let category: Category
    
    enum RecommendationType {
        case dietary, calorie, exercise, general
    }
    
    enum Priority {
        case low, medium, high
    }
    
    enum Category {
        case nutrition, weight, hydration, exercise
    }
}

struct HealthInsight: Identifiable {
    let id = UUID()
    let type: InsightType
    let title: String
    let message: String
    let severity: Severity
    
    enum InsightType {
        case trend, timing, nutrition, pattern
    }
    
    enum Severity {
        case info, warning, alert
    }
}

struct CalorieAlert: Identifiable {
    let id = UUID()
    let type: AlertType
    let message: String
    let excessCalories: Int
    let recommendations: [FoodProduct]
    
    enum AlertType {
        case warning, exceeded
    }
} 
