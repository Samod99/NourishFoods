# Map Functionality Update

This document describes the updated map functionality with real-time location tracking and delivery simulation.

## Overview

The map system now uses the user's actual current location and implements proper delivery tracking from the restaurant to the user's location.

## Key Features

### 1. **Real-Time Location Tracking**
- Uses device GPS to get user's current location
- Automatically requests location permissions
- Updates location in real-time during delivery

### 2. **Fixed Pickup Location**
- Restaurant pickup location: **6.9271° N, 79.8612° E**
- Driver starts from restaurant location
- Moves toward user's current location

### 3. **Delivery Simulation**
- Driver moves from restaurant to user location
- Real-time distance and time calculations
- 30-step delivery simulation (30 seconds total)
- Progressive status updates

### 4. **Map Annotations**
- **Orange Pin**: Restaurant location (pickup point)
- **Green Pin**: Driver location (moving)
- **Red Pin**: User location (delivery destination)

## Implementation Details

### LocationManager.swift
**New service for handling location permissions and updates:**

```swift
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var locationError: String?
    @Published var isLocationEnabled = false
    
    // Methods for location handling
    func requestLocationPermission()
    func startLocationUpdates()
    func calculateDistance(from:to:)
    func formatDistance(_ distance: Double)
    func formatTime(_ distance: Double)
}
```

### DemoMapViewModel.swift
**Updated with real location tracking:**

```swift
class DemoMapViewModel: ObservableObject {
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var deliveryLocation: CLLocationCoordinate2D? // User's location
    @Published var pickupLocation: CLLocationCoordinate2D? // Restaurant
    @Published var driverLocation: CLLocationCoordinate2D? // Driver
    @Published var status: String = "Ready"
    @Published var estimatedTime: String = ""
    @Published var distanceRemaining: String = ""
    
    // Restaurant location (fixed)
    private let restaurantLocation = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
}
```

### DeliveryTrackingView.swift
**Enhanced with real-time tracking:**

- Real-time map updates
- Distance and time calculations
- Progress tracking
- Review system after delivery

## Delivery Flow

### 1. **Initialization**
```
App starts → Location permission request → Get user location → Set pickup location
```

### 2. **Delivery Start**
```
User location detected → Driver starts at restaurant → Begin 30-step simulation
```

### 3. **Progress Updates**
```
Steps 1-5: "Order Confirmed"
Steps 6-10: "Preparing Food"
Steps 11-15: "Driver Picked Up"
Steps 16-20: "On the Way"
Steps 21-25: "Almost There"
Steps 26-30: "Arriving Soon"
Step 30+: "Delivered"
```

### 4. **Real-Time Calculations**
- **Distance**: Calculated between driver and user
- **Time**: Estimated based on 30 km/h average speed
- **Progress**: Visual progress bar (30 steps)

## Map Features

### **Three Map Pins**
1. **Restaurant (Orange)**: Fixed at 6.9271° N, 79.8612° E
2. **Driver (Green)**: Moves from restaurant to user
3. **User (Red)**: User's current location

### **Dynamic Map Region**
- Centers between driver and user location
- Automatically adjusts as driver moves
- Shows optimal view of delivery progress

### **Real-Time Updates**
- Driver location updates every second
- Distance and time recalculated
- Map region adjusts automatically

## Location Permissions

### **Required Permissions**
- `NSLocationWhenInUseUsageDescription` - For delivery tracking
- Automatic permission request on app start

### **Permission Handling**
```swift
// In LocationService.swift
func requestPermission() {
    locationManager.requestWhenInUseAuthorization()
}
```

## Benefits

1. **Real Location**: Uses actual device GPS
2. **Accurate Tracking**: Real distance and time calculations
3. **User Experience**: Smooth delivery simulation
4. **Visual Feedback**: Clear map with multiple pins
5. **Progress Tracking**: Real-time status updates

## Usage

### **Starting Delivery**
```swift
viewModel.startDelivery() // Automatically called when view appears
```

### **Getting Map Data**
```swift
let region = viewModel.getMapRegion()
let annotations = viewModel.getMapAnnotations()
```

### **Tracking Progress**
```swift
let status = viewModel.status
let distance = viewModel.distanceRemaining
let time = viewModel.estimatedTime
```

## Technical Details

### **Location Accuracy**
- Best accuracy for precise tracking
- Updates every 10 meters of movement
- Handles location errors gracefully

### **Performance**
- Efficient location updates
- Smooth map animations
- Minimal battery impact

### **Error Handling**
- Graceful fallback for location errors
- User-friendly error messages
- Automatic retry mechanisms

The map system now provides a realistic delivery tracking experience with actual location data and smooth animations! 