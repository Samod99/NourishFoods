import SwiftUI

struct HealthProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var healthViewModel: HealthTrackingViewModel
    
    @State private var age = ""
    @State private var weight = ""
    @State private var height = ""
    @State private var selectedGender = HealthProfile.Gender.male
    @State private var selectedActivityLevel = HealthProfile.ActivityLevel.moderatelyActive
    @State private var selectedGoal = HealthProfile.HealthGoal.maintainWeight
    @State private var selectedDietaryRestrictions: Set<HealthProfile.DietaryRestriction> = []
    @State private var allergies = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HeaderSection()
                    
                    BasicInformationSection(
                        age: $age,
                        weight: $weight,
                        height: $height,
                        selectedGender: $selectedGender
                    )
                    
                    ActivityLevelSection(
                        selectedActivityLevel: $selectedActivityLevel
                    )
                    
                    HealthGoalSection(
                        selectedGoal: $selectedGoal
                    )
                    
                    DietaryRestrictionsSection(
                        selectedDietaryRestrictions: $selectedDietaryRestrictions
                    )
                    
                    AllergiesSection(allergies: $allergies)
                    
                    if let estimatedCalories = getEstimatedCalories() {
                        CalorieEstimateSection(estimatedCalories: estimatedCalories)
                    }
                    
                    SaveButtonSection(
                        isFormValid: isFormValid,
                        saveProfile: saveProfile
                    )
                }
                .padding()
            }
            .background(Color.viewBackground)
            .navigationTitle("Health Profile")
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
    
    // MARK: - Helper Methods
    private var isFormValid: Bool {
        !age.isEmpty && !weight.isEmpty && !height.isEmpty &&
        Int(age) != nil && Double(weight) != nil && Double(height) != nil
    }
    
    private func getEstimatedCalories() -> Int? {
        guard let ageInt = Int(age),
              let weightDouble = Double(weight),
              let heightDouble = Double(height) else { return nil }
        
        let profile = HealthProfile(
            userId: "",
            age: ageInt,
            weight: weightDouble,
            height: heightDouble,
            gender: selectedGender,
            activityLevel: selectedActivityLevel,
            goal: selectedGoal,
            dietaryRestrictions: Array(selectedDietaryRestrictions),
            allergies: allergies.isEmpty ? [] : allergies.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        )
        
        return profile.dailyCalorieNeeds
    }
    
    private func saveProfile() {
        guard let ageInt = Int(age),
              let weightDouble = Double(weight),
              let heightDouble = Double(height) else { return }
        
        let allergiesList = allergies.isEmpty ? [] : allergies.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        healthViewModel.createHealthProfile(
            age: ageInt,
            weight: weightDouble,
            height: heightDouble,
            gender: selectedGender,
            activityLevel: selectedActivityLevel,
            goal: selectedGoal,
            dietaryRestrictions: Array(selectedDietaryRestrictions),
            allergies: allergiesList
        )
        
        dismiss()
    }
}

// MARK: - Sub-Views
struct HeaderSection: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "heart.fill")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Health Profile Setup")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Help us provide personalized recommendations")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.top)
    }
}

struct BasicInformationSection: View {
    @Binding var age: String
    @Binding var weight: String
    @Binding var height: String
    @Binding var selectedGender: HealthProfile.Gender
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Basic Information")
                .font(.headline)
                .fontWeight(.semibold)
            
            // Age
            VStack(alignment: .leading, spacing: 5) {
                Text("Age")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("Enter your age", text: $age)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }
            
            // Weight
            VStack(alignment: .leading, spacing: 5) {
                Text("Weight (kg)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("Enter your weight", text: $weight)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
            }
            
            // Height
            VStack(alignment: .leading, spacing: 5) {
                Text("Height (cm)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("Enter your height", text: $height)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
            }
            
            // Gender
            VStack(alignment: .leading, spacing: 5) {
                Text("Gender")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Picker("Gender", selection: $selectedGender) {
                    ForEach(HealthProfile.Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue).tag(gender)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct ActivityLevelSection: View {
    @Binding var selectedActivityLevel: HealthProfile.ActivityLevel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Activity Level")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 10) {
                ForEach(HealthProfile.ActivityLevel.allCases, id: \.self) { level in
                    ActivityLevelButton(
                        level: level,
                        isSelected: selectedActivityLevel == level,
                        action: { selectedActivityLevel = level }
                    )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct ActivityLevelButton: View {
    let level: HealthProfile.ActivityLevel
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(level.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(getActivityDescription(level))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.buttonBackground)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.buttonBackground.opacity(0.1) : Color.gray.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getActivityDescription(_ level: HealthProfile.ActivityLevel) -> String {
        switch level {
        case .sedentary:
            return "Little or no exercise"
        case .lightlyActive:
            return "Light exercise 1-3 days/week"
        case .moderatelyActive:
            return "Moderate exercise 3-5 days/week"
        case .veryActive:
            return "Hard exercise 6-7 days/week"
        case .extremelyActive:
            return "Very hard exercise, physical job"
        }
    }
}

struct HealthGoalSection: View {
    @Binding var selectedGoal: HealthProfile.HealthGoal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Health Goal")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 10) {
                ForEach(HealthProfile.HealthGoal.allCases, id: \.self) { goal in
                    HealthGoalButton(
                        goal: goal,
                        isSelected: selectedGoal == goal,
                        action: { selectedGoal = goal }
                    )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct HealthGoalButton: View {
    let goal: HealthProfile.HealthGoal
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(goal.rawValue)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(getGoalDescription(goal))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.buttonBackground)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.buttonBackground.opacity(0.1) : Color.gray.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func getGoalDescription(_ goal: HealthProfile.HealthGoal) -> String {
        switch goal {
        case .loseWeight:
            return "Reduce daily calorie intake"
        case .maintainWeight:
            return "Maintain current weight"
        case .gainWeight:
            return "Increase daily calorie intake"
        case .buildMuscle:
            return "Focus on protein and strength training"
        }
    }
}

struct DietaryRestrictionsSection: View {
    @Binding var selectedDietaryRestrictions: Set<HealthProfile.DietaryRestriction>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Dietary Restrictions")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(HealthProfile.DietaryRestriction.allCases, id: \.self) { restriction in
                    DietaryRestrictionButton(
                        restriction: restriction,
                        isSelected: selectedDietaryRestrictions.contains(restriction),
                        action: {
                            if selectedDietaryRestrictions.contains(restriction) {
                                selectedDietaryRestrictions.remove(restriction)
                            } else {
                                selectedDietaryRestrictions.insert(restriction)
                            }
                        }
                    )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct DietaryRestrictionButton: View {
    let restriction: HealthProfile.DietaryRestriction
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(restriction.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? Color.buttonBackground : Color.gray.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AllergiesSection: View {
    @Binding var allergies: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Allergies")
                .font(.headline)
                .fontWeight(.semibold)
            
            TextField("Enter any food allergies (comma separated)", text: $allergies)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct CalorieEstimateSection: View {
    let estimatedCalories: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Estimated Daily Calorie Needs")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("\(estimatedCalories) calories")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.buttonBackground)
            
            Text("Based on your profile")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.buttonBackground.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SaveButtonSection: View {
    let isFormValid: Bool
    let saveProfile: () -> Void
    
    var body: some View {
        Button(action: saveProfile) {
            Text("Save Profile")
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
        .disabled(!isFormValid)
        .opacity(isFormValid ? 1.0 : 0.6)
        .padding(.top)
    }
}

#Preview {
    HealthProfileView(healthViewModel: HealthTrackingViewModel())
} 
