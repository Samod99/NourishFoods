import Foundation
import SwiftUI

@MainActor
class HealthTrackingViewModel: ObservableObject {
    @Published var healthAI = HealthAI()
    @Published var showingHealthProfile = false
    @Published var showingCalorieAlert = false
    @Published var showingHealthInsights = false
    @Published var selectedMealType: DailyCalorieEntry.MealType = .lunch
    
    private let userDefaults = UserDefaults.standard
    private let healthProfileKey = "userHealthProfile"
    private let calorieEntriesKey = "dailyCalorieEntries"
    private let lastResetDateKey = "lastCalorieResetDate"
    
    init() {
        loadHealthProfile()
        loadCalorieEntries()
        checkAndResetDailyCalories()
    }
    
    // MARK: - Daily Calorie Reset
    private func checkAndResetDailyCalories() {
        let today = Calendar.current.startOfDay(for: Date())
        let lastResetDate = getLastResetDate()
        
        if !Calendar.current.isDate(lastResetDate, inSameDayAs: today) {
            // New day, reset calories
            resetDailyCalories()
            setLastResetDate(today)
        }
    }
    
    // MARK: - Manual Reset (for testing)
    func manualResetCalories() {
        resetDailyCalories()
        setLastResetDate(Date.distantPast) // Force reset on next check
        print("Manual calorie reset completed")
    }
    
    private func getLastResetDate() -> Date {
        if let dateData = userDefaults.data(forKey: lastResetDateKey),
           let date = try? JSONDecoder().decode(Date.self, from: dateData) {
            return date
        }
        return Date.distantPast
    }
    
    private func setLastResetDate(_ date: Date) {
        if let dateData = try? JSONEncoder().encode(date) {
            userDefaults.set(dateData, forKey: lastResetDateKey)
        }
    }
    
    private func resetDailyCalories() {
        healthAI.dailyEntries.removeAll()
        saveCalorieEntries()
        print("Daily calories reset for new day")
    }
    
    // MARK: - Health Profile Management
    func createHealthProfile(
        age: Int,
        weight: Double,
        height: Double,
        gender: HealthProfile.Gender,
        activityLevel: HealthProfile.ActivityLevel,
        goal: HealthProfile.HealthGoal,
        dietaryRestrictions: [HealthProfile.DietaryRestriction],
        allergies: [String]
    ) {
        let profile = HealthProfile(
            userId: UUID().uuidString,
            age: age,
            weight: weight,
            height: height,
            gender: gender,
            activityLevel: activityLevel,
            goal: goal,
            dietaryRestrictions: dietaryRestrictions,
            allergies: allergies
        )
        
        healthAI.healthProfile = profile
        saveHealthProfile()
    }
    
    func updateHealthProfile(_ profile: HealthProfile) {
        healthAI.healthProfile = profile
        saveHealthProfile()
    }
    
    private func saveHealthProfile() {
        if let profile = healthAI.healthProfile,
           let data = try? JSONEncoder().encode(profile) {
            userDefaults.set(data, forKey: healthProfileKey)
        }
    }
    
    private func loadHealthProfile() {
        if let data = userDefaults.data(forKey: healthProfileKey),
           let profile = try? JSONDecoder().decode(HealthProfile.self, from: data) {
            healthAI.healthProfile = profile
        }
    }
    
    // MARK: - Calorie Tracking
    func addFoodToTracking(_ product: FoodProduct, quantity: Int) {
        // Check if it's a new day and reset if needed
        checkAndResetDailyCalories()
        
        healthAI.addFoodEntry(product, quantity: quantity, mealType: selectedMealType)
        saveCalorieEntries()
        
        // Show alert if calorie limit is exceeded
        if healthAI.calorieAlert != nil {
            showingCalorieAlert = true
        }
    }
    
    // MARK: - Purchase Tracking (called after successful purchase)
    func trackPurchase(_ cartItems: [CartItem]) {
        // Check if it's a new day and reset if needed
        checkAndResetDailyCalories()
        
        for item in cartItems {
            healthAI.addFoodEntry(item.product, quantity: item.quantity, mealType: .lunch) // Default to lunch, can be improved
        }
        
        saveCalorieEntries()
        
        // Show alert if calorie limit is exceeded
        if healthAI.calorieAlert != nil {
            showingCalorieAlert = true
        }
    }
    
    func removeFoodEntry(_ entry: DailyCalorieEntry) {
        healthAI.dailyEntries.removeAll { $0.id == entry.id }
        saveCalorieEntries()
        healthAI.analyzeCalorieIntake()
        healthAI.generateRecommendations()
    }
    
    private func saveCalorieEntries() {
        if let data = try? JSONEncoder().encode(healthAI.dailyEntries) {
            userDefaults.set(data, forKey: calorieEntriesKey)
        }
    }
    
    private func loadCalorieEntries() {
        if let data = userDefaults.data(forKey: calorieEntriesKey),
           let entries = try? JSONDecoder().decode([DailyCalorieEntry].self, from: data) {
            healthAI.dailyEntries = entries
        }
    }
    
    // MARK: - Daily Calorie Analytics
    func getTodayCalories() -> Int {
        checkAndResetDailyCalories() // Ensure we're tracking current day
        return healthAI.getTodayCalories()
    }
    
    func getTodayCaloriesFormatted() -> String {
        return "\(getTodayCalories()) cal"
    }
    
    func getAverageCaloriesPerDay() -> Int {
        let weeklyCalories = healthAI.getWeeklyCalories()
        guard !weeklyCalories.isEmpty else { return 0 }
        return weeklyCalories.reduce(0, +) / weeklyCalories.count
    }
    
    func getAverageCaloriesFormatted() -> String {
        return "\(getAverageCaloriesPerDay()) cal/day"
    }
    
    func getCalorieProgress() -> Double {
        guard let profile = healthAI.healthProfile else { return 0.0 }
        let todayCalories = getTodayCalories()
        return min(Double(todayCalories) / Double(profile.dailyCalorieNeeds), 1.0)
    }
    
    func getCalorieProgressColor() -> Color {
        let progress = getCalorieProgress()
        switch progress {
        case 0.0..<0.6:
            return .green
        case 0.6..<0.8:
            return .orange
        case 0.8..<1.0:
            return .red
        default:
            return .red
        }
    }
    
    func getMealBreakdown() -> [String: Int] {
        checkAndResetDailyCalories() // Ensure we're tracking current day
        let today = Calendar.current.startOfDay(for: Date())
        let todayEntries = healthAI.dailyEntries.filter { 
            Calendar.current.isDate($0.date, inSameDayAs: today) 
        }
        
        var breakdown: [String: Int] = [:]
        for mealType in DailyCalorieEntry.MealType.allCases {
            let mealCalories = todayEntries
                .filter { $0.mealType == mealType }
                .reduce(0) { $0 + $1.totalCalories }
            breakdown[mealType.rawValue] = mealCalories
        }
        
        return breakdown
    }
    
    // MARK: - Daily Food Entries List
    func getTodayFoodEntries() -> [DailyCalorieEntry] {
        checkAndResetDailyCalories() // Ensure we're tracking current day
        let today = Calendar.current.startOfDay(for: Date())
        return healthAI.dailyEntries.filter { 
            Calendar.current.isDate($0.date, inSameDayAs: today) 
        }.sorted { $0.timestamp > $1.timestamp }
    }
    
    // MARK: - AI Recommendations
    func getPersonalizedRecommendations() -> [FoodProduct] {
        guard let profile = healthAI.healthProfile else { return [] }
        
        let todayCalories = getTodayCalories()
        let remainingCalories = profile.dailyCalorieNeeds - todayCalories
        
        if remainingCalories <= 0 {
            // User exceeded limit, suggest very low calorie options
            return SampleData.sampleFoodProducts.filter { product in
                product.calories <= 200 &&
                !profile.allergies.contains { product.allergens.contains($0) }
            }.prefix(3).map { $0 }
        } else {
            // Suggest healthy options within remaining calories
            return SampleData.sampleFoodProducts.filter { product in
                product.calories <= remainingCalories &&
                product.calories <= 400 &&
                [.salads, .fruits, .juices, .vegetarian, .seafood].contains(product.productType) &&
                !profile.allergies.contains { product.allergens.contains($0) }
            }.prefix(5).map { $0 }
        }
    }
    
    // MARK: - Health Insights
    func getWeeklyTrend() -> String {
        let weeklyCalories = healthAI.getWeeklyCalories()
        guard weeklyCalories.count >= 2 else { return "Insufficient data" }
        
        let recentDays = Array(weeklyCalories.suffix(3))
        let earlierDays = Array(weeklyCalories.prefix(3))
        
        let recentAverage = recentDays.reduce(0, +) / recentDays.count
        let earlierAverage = earlierDays.reduce(0, +) / earlierDays.count
        
        if recentAverage > earlierAverage * Int(1.1) {
            return "📈 Increasing trend"
        } else if recentAverage < earlierAverage * Int(0.9) {
            return "📉 Decreasing trend"
        } else {
            return "➡️ Stable trend"
        }
    }
    
    // MARK: - Notifications
    func scheduleCalorieReminders() {
        // This would integrate with local notifications
        // For now, just a placeholder
        print("Calorie reminders scheduled")
    }
    
    func sendCalorieAlert() {
        if let alert = healthAI.calorieAlert {
            // This would integrate with your notification system
            NotificationService.shared.sendCalorieAlertNotification(
                title: "Calorie Alert",
                body: alert.message
            )
        }
    }
}

// MARK: - Extensions for UI
extension HealthTrackingViewModel {
    func getCalorieStatusText() -> String {
        guard let profile = healthAI.healthProfile else { return "Set up your health profile" }
        
        let todayCalories = getTodayCalories()
        let remaining = profile.dailyCalorieNeeds - todayCalories
        
        if remaining > 0 {
            return "\(remaining) calories remaining"
        } else {
            return "\(abs(remaining)) calories over limit"
        }
    }
    
    func getCalorieStatusColor() -> Color {
        guard let profile = healthAI.healthProfile else { return .gray }
        
        let todayCalories = getTodayCalories()
        let remaining = profile.dailyCalorieNeeds - todayCalories
        
        if remaining > 0 {
            return .green
        } else {
            return .red
        }
    }
    
    func getBMIStatus() -> (String, Color) {
        guard let profile = healthAI.healthProfile else { return ("N/A", .gray) }
        
        let bmi = profile.bmi
        let category = profile.bmiCategory
        
        switch category {
        case "Underweight":
            return ("BMI: \(String(format: "%.1f", bmi)) - Underweight", .orange)
        case "Normal":
            return ("BMI: \(String(format: "%.1f", bmi)) - Normal", .green)
        case "Overweight":
            return ("BMI: \(String(format: "%.1f", bmi)) - Overweight", .orange)
        case "Obese":
            return ("BMI: \(String(format: "%.1f", bmi)) - Obese", .red)
        default:
            return ("BMI: \(String(format: "%.1f", bmi))", .gray)
        }
    }
} 
