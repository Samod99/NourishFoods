import SwiftUI
import Charts

struct HealthDashboardView: View {
    @ObservedObject var healthViewModel: HealthTrackingViewModel
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var showingAddFood = false
    @State private var selectedProduct: FoodProduct?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Daily Calorie Summary
                    DailyCalorieSummaryCard(healthViewModel: healthViewModel)
                    
                    // Header with Profile Status
                    if let profile = healthViewModel.healthAI.healthProfile {
                        HealthProfileHeader(profile: profile, healthViewModel: healthViewModel)
                    } else {
                        SetupHealthProfileCard(healthViewModel: healthViewModel)
                    }
                    
                    // Calorie Progress
                    if healthViewModel.healthAI.healthProfile != nil {
                        CalorieProgressCard(healthViewModel: healthViewModel)
                        
                        // Meal Breakdown
                        MealBreakdownCard(healthViewModel: healthViewModel)
                        
                        // AI Recommendations
                        AIRecommendationsCard(healthViewModel: healthViewModel)
                        
                        // Health Insights
                        HealthInsightsCard(healthViewModel: healthViewModel)
                        
                        // Today's Food Log
                        FoodLogCard(healthViewModel: healthViewModel)
                    }
                }
                .padding()
            }
            .background(Color.viewBackground)
            .navigationTitle("Health Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingAddFood) {
                AddFoodView(healthViewModel: healthViewModel)
            }
            .alert("Calorie Alert", isPresented: $healthViewModel.showingCalorieAlert) {
                Button("OK") {
                    healthViewModel.showingCalorieAlert = false
                }
                Button("View Recommendations") {
                    // Scroll to recommendations
                }
            } message: {
                if let alert = healthViewModel.healthAI.calorieAlert {
                    Text(alert.message)
                }
            }
        }
    }
}

// MARK: - Health Profile Header
struct HealthProfileHeader: View {
    let profile: HealthProfile
    @ObservedObject var healthViewModel: HealthTrackingViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Daily Goal")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("\(profile.dailyCalorieNeeds) calories")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.buttonBackground)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("Today")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(healthViewModel.getTodayCaloriesFormatted())
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(healthViewModel.getCalorieStatusColor())
                }
            }
            
            let (bmiText, bmiColor) = healthViewModel.getBMIStatus()
            HStack {
                Text(bmiText)
                    .font(.subheadline)
                    .foregroundColor(bmiColor)
                
                Spacer()
                
                Text(healthViewModel.getWeeklyTrend())
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Setup Health Profile Card
struct SetupHealthProfileCard: View {
    @ObservedObject var healthViewModel: HealthTrackingViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "heart.fill")
                .font(.system(size: 40))
                .foregroundColor(.red)
            
            Text("Set Up Your Health Profile")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Get personalized calorie tracking and AI-powered recommendations")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button(action: {
                healthViewModel.showingHealthProfile = true
            }) {
                Text("Set Up Profile")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.buttonBackground)
                    )
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .sheet(isPresented: $healthViewModel.showingHealthProfile) {
            HealthProfileView(healthViewModel: healthViewModel)
        }
    }
}

// MARK: - Calorie Progress Card
struct CalorieProgressCard: View {
    @ObservedObject var healthViewModel: HealthTrackingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Calorie Progress")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 10) {
                HStack {
                    Text("Today's Progress")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(healthViewModel.getCalorieStatusText())
                        .font(.subheadline)
                        .foregroundColor(healthViewModel.getCalorieStatusColor())
                }
                
                ProgressView(value: healthViewModel.getCalorieProgress())
                    .progressViewStyle(LinearProgressViewStyle(tint: healthViewModel.getCalorieProgressColor()))
                    .scaleEffect(x: 1, y: 2, anchor: .center)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Meal Breakdown Card
struct MealBreakdownCard: View {
    @ObservedObject var healthViewModel: HealthTrackingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Meal Breakdown")
                .font(.headline)
                .fontWeight(.semibold)
            
            let breakdown = healthViewModel.getMealBreakdown()
            
            VStack(spacing: 10) {
                ForEach(DailyCalorieEntry.MealType.allCases, id: \.self) { mealType in
                    HStack {
                        Text(mealType.icon)
                            .font(.title3)
                        
                        Text(mealType.rawValue)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Text("\(breakdown[mealType.rawValue] ?? 0) cal")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - AI Recommendations Card
struct AIRecommendationsCard: View {
    @ObservedObject var healthViewModel: HealthTrackingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.buttonBackground)
                
                Text("AI Recommendations")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            let recommendations = healthViewModel.getPersonalizedRecommendations()
            
            if recommendations.isEmpty {
                Text("No recommendations available")
                    .font(.body)
                    .foregroundColor(.gray)
                    .italic()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(recommendations, id: \.id) { product in
                            RecommendationCard(product: product)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct RecommendationCard: View {
    let product: FoodProduct
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let imageURL = product.imageURL, !imageURL.isEmpty {
                Image(imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Image("burger01")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            }
            
            Text(product.shortName)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
            
            Text("\(product.calories) cal")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 100)
    }
}

// MARK: - Health Insights Card
struct HealthInsightsCard: View {
    @ObservedObject var healthViewModel: HealthTrackingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                
                Text("Health Insights")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            let insights = healthViewModel.healthAI.getHealthInsights()
            
            if insights.isEmpty {
                Text("No insights available yet")
                    .font(.body)
                    .foregroundColor(.gray)
                    .italic()
            } else {
                VStack(spacing: 10) {
                    ForEach(insights) { insight in
                        InsightRow(insight: insight)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct InsightRow: View {
    let insight: HealthInsight
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: getInsightIcon())
                .foregroundColor(getInsightColor())
                .font(.caption)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(insight.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(insight.message)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 5)
    }
    
    private func getInsightIcon() -> String {
        switch insight.type {
        case .trend: return "chart.line.uptrend.xyaxis"
        case .timing: return "clock"
        case .nutrition: return "leaf"
        case .pattern: return "chart.bar"
        }
    }
    
    private func getInsightColor() -> Color {
        switch insight.severity {
        case .info: return .blue
        case .warning: return .orange
        case .alert: return .red
        }
    }
}

// MARK: - Daily Calorie Summary Card
struct DailyCalorieSummaryCard: View {
    @ObservedObject var healthViewModel: HealthTrackingViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Today's Calories")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(healthViewModel.getTodayCaloriesFormatted())
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.buttonBackground)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("Average (7 days)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text(healthViewModel.getAverageCaloriesFormatted())
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
            }
            
            if let profile = healthViewModel.healthAI.healthProfile {
                let progress = healthViewModel.getCalorieProgress()
                let remaining = profile.dailyCalorieNeeds - healthViewModel.getTodayCalories()
                
                HStack {
                    Text("Daily Goal: \(profile.dailyCalorieNeeds) cal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if remaining > 0 {
                        Text("\(remaining) cal remaining")
                            .font(.caption)
                            .foregroundColor(.green)
                            .fontWeight(.medium)
                    } else {
                        Text("\(abs(remaining)) cal over limit")
                            .font(.caption)
                            .foregroundColor(.red)
                            .fontWeight(.medium)
                    }
                }
                
                // Progress Bar
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: healthViewModel.getCalorieProgressColor()))
                    .scaleEffect(y: 2)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

// MARK: - Food Log Card
struct FoodLogCard: View {
    @ObservedObject var healthViewModel: HealthTrackingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "list.bullet")
                    .foregroundColor(.buttonBackground)
                
                Text("Today's Food Log")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("\(healthViewModel.getTodayFoodEntries().count) items")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            let todayEntries = healthViewModel.getTodayFoodEntries()
            
            if todayEntries.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "fork.knife")
                        .font(.title2)
                        .foregroundColor(.gray)
                    
                    Text("No food logged today")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Add food items to track your daily intake")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(todayEntries) { entry in
                        FoodLogEntryRow(entry: entry) {
                            healthViewModel.removeFoodEntry(entry)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

// MARK: - Food Log Entry Row
struct FoodLogEntryRow: View {
    let entry: DailyCalorieEntry
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Food Image
            if let imageURL = entry.foodProduct.imageURL, !imageURL.isEmpty {
                Image(imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(8)
            } else {
                Image("burger01")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.foodProduct.shortName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                HStack {
                    Text(entry.mealType.icon)
                        .font(.caption)
                    
                    Text(entry.mealType.rawValue)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    if entry.quantity > 1 {
                        Text("× \(entry.quantity)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(entry.totalCalories) cal")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.buttonBackground)
                
                Text(entry.timestamp, style: .time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding(.vertical, 5)
    }
}

// MARK: - Add Food View
struct AddFoodView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var healthViewModel: HealthTrackingViewModel
    @State private var searchText = ""
    @State private var selectedQuantity = 1
    
    var filteredProducts: [FoodProduct] {
        if searchText.isEmpty {
            return SampleData.sampleFoodProducts
        } else {
            return SampleData.sampleFoodProducts.filter { product in
                product.shortName.localizedCaseInsensitiveContains(searchText) ||
                product.longName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search for food...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Meal Type Selector
                Picker("Meal Type", selection: $healthViewModel.selectedMealType) {
                    ForEach(DailyCalorieEntry.MealType.allCases, id: \.self) { mealType in
                        Text(mealType.rawValue).tag(mealType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Food List
                List(filteredProducts, id: \.id) { product in
                    Button(action: {
                        healthViewModel.addFoodToTracking(product, quantity: selectedQuantity)
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(product.shortName)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                Text("\(product.calories) calories")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text("+\(product.calories * selectedQuantity) cal")
                                .font(.caption)
                                .foregroundColor(.buttonBackground)
                                .fontWeight(.medium)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    HealthDashboardView(healthViewModel: HealthTrackingViewModel())
        .environmentObject(CartViewModel())
} 