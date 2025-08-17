# Calorie Tracking System

This document describes the calorie tracking system implemented for the Nourish Foods app to monitor daily calorie intake and provide health insights.

## Overview

The calorie tracking system automatically tracks calories from food purchases and manual entries, resets daily, and provides comprehensive health analytics.

## Key Features

### 1. **Automatic Daily Reset**
- Calories reset automatically at the start of each new day
- Uses `lastResetDateKey` to track when calories were last reset
- Ensures clean daily tracking without manual intervention

### 2. **Purchase-Based Tracking**
- Automatically adds calories when orders are completed
- Called from `CartViewModel.completeOrder()` with `trackPurchase()` method
- Tracks all items in cart with their quantities

### 3. **Manual Food Entry**
- Users can manually add food items through the health dashboard
- Supports different meal types (Breakfast, Lunch, Dinner, Snack)
- Real-time calorie calculation and tracking

### 4. **Daily Calorie Analytics**
- **Today's Calories**: Current day's total calorie intake
- **Average Calories**: 7-day average calorie consumption
- **Progress Tracking**: Visual progress bar towards daily goal
- **Remaining Calories**: Shows how many calories are left for the day

## Implementation Details

### HealthTrackingViewModel Updates

#### New Properties:
- `lastResetDateKey`: Tracks when calories were last reset
- `getTodayCalories()`: Returns current day's calorie count
- `getTodayCaloriesFormatted()`: Returns formatted calorie string
- `getAverageCaloriesPerDay()`: Returns 7-day average
- `getAverageCaloriesFormatted()`: Returns formatted average string
- `getTodayFoodEntries()`: Returns today's food entries sorted by time

#### New Methods:
- `checkAndResetDailyCalories()`: Checks and resets calories for new day
- `trackPurchase()`: Tracks calories from completed orders
- `manualResetCalories()`: Manual reset for testing

### CartViewModel Integration

The `completeOrder()` method now accepts a `HealthTrackingViewModel` parameter and calls `trackPurchase()` after successful order completion:

```swift
func completeOrder(
    deliveryAddress: String? = nil, 
    paymentMethod: String? = nil, 
    healthViewModel: HealthTrackingViewModel? = nil, 
    completion: @escaping (Bool) -> Void = { _ in }
)
```

### UI Updates

#### Daily Calorie Summary Card
- Shows today's calories prominently at the top
- Displays 7-day average for comparison
- Progress bar showing progress towards daily goal
- Remaining/over-limit calorie display

#### Enhanced Food Log
- Lists all food entries for the current day
- Shows food images, meal types, quantities, and timestamps
- Allows deletion of individual entries
- Empty state with helpful messaging

## Data Flow

1. **Purchase Flow**:
   ```
   User completes order → CartViewModel.completeOrder() → 
   HealthTrackingViewModel.trackPurchase() → 
   DailyCalorieEntry added → Calories updated
   ```

2. **Manual Entry Flow**:
   ```
   User adds food → HealthTrackingViewModel.addFoodToTracking() → 
   DailyCalorieEntry added → Calories updated
   ```

3. **Daily Reset Flow**:
   ```
   App starts/checkAndResetDailyCalories() → 
   Compare dates → Reset if new day → 
   Clear entries and update reset date
   ```

## Storage

- **UserDefaults**: Stores calorie entries, health profile, and reset date
- **Automatic Persistence**: All data is automatically saved and loaded
- **Daily Cleanup**: Old entries are automatically cleared each day

## Health Insights

The system provides:
- **Calorie Alerts**: When daily limit is exceeded
- **Progress Tracking**: Visual progress towards daily goals
- **Trend Analysis**: Weekly calorie consumption trends
- **Meal Breakdown**: Calories by meal type
- **AI Recommendations**: Personalized food suggestions

## Testing

Use `manualResetCalories()` method to test the daily reset functionality:

```swift
healthViewModel.manualResetCalories()
```

## Benefits

1. **Automatic Tracking**: No manual calorie counting required
2. **Daily Fresh Start**: Clean slate every day
3. **Comprehensive Analytics**: Detailed insights and trends
4. **User-Friendly**: Simple interface with clear information
5. **Health-Focused**: Promotes healthy eating habits

## Usage Examples

### Adding Calories from Purchase
```swift
// Automatically called when order is completed
cartViewModel.completeOrder(
    deliveryAddress: "123 Main St",
    paymentMethod: "Credit Card",
    healthViewModel: healthViewModel
) { success in
    // Calories automatically tracked
}
```

### Manual Food Entry
```swift
// Add food manually
healthViewModel.addFoodToTracking(product, quantity: 2)
```

### Getting Daily Calories
```swift
let todayCalories = healthViewModel.getTodayCalories()
let formatted = healthViewModel.getTodayCaloriesFormatted() // "1,250 cal"
```

### Checking Progress
```swift
let progress = healthViewModel.getCalorieProgress() // 0.0 to 1.0
let color = healthViewModel.getCalorieProgressColor() // Green/Orange/Red
``` 