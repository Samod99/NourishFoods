import Foundation
import CoreLocation
import Combine
import MapKit // Added for MKCoordinateRegion and MKCoordinateSpan

class DemoMapViewModel: ObservableObject {
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var deliveryLocation: CLLocationCoordinate2D? // User's current location (delivery destination)
    @Published var pickupLocation: CLLocationCoordinate2D? // Restaurant location
    @Published var driverLocation: CLLocationCoordinate2D? // Driver's current location
    @Published var status: String = "Ready"
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    @Published var currentStep = 0
    @Published var estimatedTime: String = ""
    @Published var distanceRemaining: String = ""
    @Published var totalDistance: Double = 0.0
    @Published var distanceTraveled: Double = 0.0
    
    private let locationManager = LocationManager()
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()
    private var lastMapUpdate = Date()
    private let mapUpdateInterval: TimeInterval = 1.0 // Update map every 1 second
    
    // Restaurant pickup location (fixed)
    private let restaurantLocation = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
    
    // Driver speed in meters per second (5 km/h = 1.39 m/s)
    private let driverSpeed: Double = 1.39 // 5 km/h in m/s
    
    init() {
        setupLocationManager()
        setupPickupLocation()
    }
    
    private func setupLocationManager() {
        // Subscribe to location updates
        locationManager.$currentLocation
            .sink { [weak self] location in
                DispatchQueue.main.async {
                    self?.handleLocationUpdate(location)
                }
            }
            .store(in: &cancellables)
        
        // Subscribe to location errors
        locationManager.$locationError
            .sink { [weak self] error in
                if let error = error {
                    print("Location error: \(error)")
                }
            }
            .store(in: &cancellables)
        
        // Request location permission and start updates
        locationManager.requestLocationPermission()
    }
    
    private func setupPickupLocation() {
        pickupLocation = restaurantLocation
    }
    
    private func handleLocationUpdate(_ location: CLLocationCoordinate2D?) {
        guard let location = location else { return }
        
        // Always update user's current location (delivery destination)
        deliveryLocation = location
        
        // If this is the first location update, set it as current location
        if currentLocation == nil {
            currentLocation = location
        }
        
        // If delivery is running, update driver location
        if isRunning {
            // Calculate distance to move based on speed
            let distanceToMove = driverSpeed * 0.5
            updateDriverLocation(distanceToMove: distanceToMove)
        }
        // Debug: Print locations
        print("[DEBUG] User location: \(location.latitude), \(location.longitude)")
        print("[DEBUG] Driver location: \(String(describing: driverLocation))")
    }
    
    func startDelivery() {
        guard let userLocation = deliveryLocation else {
            print("User location not available")
            return
        }
        
        // Set initial driver location at restaurant
        driverLocation = restaurantLocation
        currentLocation = userLocation
        
        // Calculate total distance
        totalDistance = locationManager.calculateDistance(from: restaurantLocation, to: userLocation)
        distanceTraveled = 0.0
        
        isRunning = true
        status = "Order Confirmed"
        currentStep = 0
        
        // Start delivery simulation
        startDeliverySimulation()
    }
    
    func startDemo() {
        startDelivery()
    }
    
    func togglePause() {
        isPaused.toggle()
    }
    
    func pause() {
        isPaused = true
    }
    
    func resume() {
        isPaused = false
    }
    
    private func startDeliverySimulation() {
        timer?.invalidate()
        isPaused = false
        
        // Update every 0.5 seconds for smoother movement
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            if self?.isPaused == false {
                self?.updateDeliveryProgress()
            }
        }
    }
    
    private func updateDeliveryProgress() {
        guard let driverLocation = driverLocation,
              let userLocation = deliveryLocation else { return }
        
        // Calculate distance to move based on speed (0.5 seconds * 1.39 m/s = 0.695 meters per update)
        let distanceToMove = driverSpeed * 0.5
        
        // Update distance traveled
        distanceTraveled += distanceToMove
        
        // Calculate progress percentage
        let progressPercentage = min(distanceTraveled / totalDistance, 1.0)
        
        // Update status based on progress percentage
        if progressPercentage < 0.2 {
            status = "Order Confirmed"
        } else if progressPercentage < 0.4 {
            status = "Preparing Food"
        } else if progressPercentage < 0.6 {
            status = "Driver Picked Up"
        } else if progressPercentage < 0.8 {
            status = "On the Way"
        } else if progressPercentage < 0.95 {
            status = "Almost There"
        } else {
            status = "Delivered"
            isRunning = false
            timer?.invalidate()
            return
        }
        
        // Move driver based on distance
        updateDriverLocation(distanceToMove: distanceToMove)
        
        // Update estimated time and distance
        updateDeliveryInfo()
    }
    
    private func updateDriverLocation(distanceToMove: Double) {
        guard let driverLocation = driverLocation,
              let userLocation = deliveryLocation else { return }
        
        let distanceToUser = locationManager.calculateDistance(from: driverLocation, to: userLocation)
        
        // If very close to user, snap to user location
        if distanceToUser < 10 {
            self.driverLocation = userLocation
            return
        }
        
        // Calculate the target position by moving toward user location
        let newDriverLocation = moveToward(from: driverLocation, to: userLocation, distance: distanceToMove)
        self.driverLocation = newDriverLocation
    }
    
    private func updateDeliveryInfo() {
        guard let driverLocation = driverLocation,
              let userLocation = deliveryLocation else { return }
        
        let distance = locationManager.calculateDistance(from: driverLocation, to: userLocation)
        distanceRemaining = locationManager.formatDistance(distance)
        
        // Calculate estimated time based on driver speed (5 km/h)
        let estimatedTimeInSeconds = distance / driverSpeed
        estimatedTime = formatTime(estimatedTimeInSeconds)
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let minutes = Int(seconds / 60)
        let remainingSeconds = Int(seconds.truncatingRemainder(dividingBy: 60))
        
        if minutes > 0 {
            return "\(minutes)m \(remainingSeconds)s"
        } else {
            return "\(remainingSeconds)s"
        }
    }
    
    private func moveToward(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, distance: Double) -> CLLocationCoordinate2D {
        let currentDistance = locationManager.calculateDistance(from: from, to: to)
        if currentDistance <= distance {
            return to
        }
        
        let fraction = distance / currentDistance
        let lat = from.latitude + (to.latitude - from.latitude) * fraction
        let lon = from.longitude + (to.longitude - from.longitude) * fraction
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func reset() {
        driverLocation = restaurantLocation
        status = "Ready"
        isRunning = false
        isPaused = false
        currentStep = 0
        distanceTraveled = 0.0
        totalDistance = 0.0
        estimatedTime = ""
        distanceRemaining = ""
        timer?.invalidate()
    }
    
    func getMapRegion() -> MKCoordinateRegion {
        guard let driverLocation = driverLocation,
              let userLocation = deliveryLocation else {
            // Default region around restaurant
            return MKCoordinateRegion(
                center: restaurantLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
        
        // Only update map region if enough time has passed to prevent excessive refreshes
        let now = Date()
        if now.timeIntervalSince(lastMapUpdate) < mapUpdateInterval {
            // Return cached region to prevent excessive updates
            let centerLat = (driverLocation.latitude + userLocation.latitude) / 2
            let centerLon = (driverLocation.longitude + userLocation.longitude) / 2
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
        
        lastMapUpdate = now
        
        // Center map between driver and user
        let centerLat = (driverLocation.latitude + userLocation.latitude) / 2
        let centerLon = (driverLocation.longitude + userLocation.longitude) / 2
        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
    
    func getMapAnnotations() -> [MapPinItem] {
        var annotations: [MapPinItem] = []
        
        // Add restaurant/pickup location
        if let pickupLocation = pickupLocation {
            annotations.append(MapPinItem(
                coordinate: pickupLocation,
                color: .orange,
                title: "Restaurant",
                icon: "building.2.fill"
            ))
        }
        
        // Add driver location (only if running to prevent excessive updates)
        if let driverLocation = driverLocation {
            annotations.append(MapPinItem(
                coordinate: driverLocation,
                color: .green,
                title: "Driver",
                icon: "car.fill"
            ))
        }
        
        // Add user location (delivery destination)
        if let userLocation = deliveryLocation {
            annotations.append(MapPinItem(
                coordinate: userLocation,
                color: .red,
                title: "Your Location",
                icon: "house.fill"
            ))
        }
        
        return annotations
    }
} 
