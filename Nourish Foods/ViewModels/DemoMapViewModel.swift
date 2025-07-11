import Foundation
import CoreLocation
import Combine

class DemoMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var pickupLocation: CLLocationCoordinate2D?
    @Published var status: String = "Ready"
    @Published var isRunning: Bool = false
    @Published var currentStep = 0

    
    private let locationManager = CLLocationManager()
    private var timer: Timer?
    private var lastPickupLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            currentLocation = loc.coordinate
            if pickupLocation == nil {
                pickupLocation = generateRandomLocation(near: loc.coordinate, maxDistanceMeters: 5000)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Fallback to mock location (Colombo)
        let mock = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
        currentLocation = mock
        if pickupLocation == nil {
            pickupLocation = generateRandomLocation(near: mock, maxDistanceMeters: 5000)
        }
    }
    
    func generateRandomLocation(near coordinate: CLLocationCoordinate2D, maxDistanceMeters: Double) -> CLLocationCoordinate2D {
        let earthRadius = 6371000.0
        let distance = Double.random(in: 1000...maxDistanceMeters)
        let bearing = Double.random(in: 0...(2 * Double.pi))
        let lat1 = coordinate.latitude * Double.pi / 180
        let lon1 = coordinate.longitude * Double.pi / 180
        let lat2 = asin(sin(lat1) * cos(distance / earthRadius) + cos(lat1) * sin(distance / earthRadius) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distance / earthRadius) * cos(lat1), cos(distance / earthRadius) - sin(lat1) * sin(lat2))
        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
    
    func startDemo() {
        // Ensure we have locations to work with
        if currentLocation == nil {
            let mock = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
            currentLocation = mock
        }
        
        if pickupLocation == nil {
            pickupLocation = generateRandomLocation(near: currentLocation!, maxDistanceMeters: 5000)
        }
        
        isRunning = true
        status = "Order Confirmed"
        currentStep = 0
        lastPickupLocation = pickupLocation
        timer?.invalidate()
        // Complete demo in 20 seconds: 20 steps * 1 second = 20 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] t in
            self?.movePickupCloser()
        }
    }
    
    private func movePickupCloser() {
        // Ensure we have valid locations
        guard let current = currentLocation, let pickup = pickupLocation else { return }
        
        currentStep += 1
        
        // Update status based on progress - 20 steps total
        if currentStep < 3 {
            status = "Order Confirmed"
        } else if currentStep < 6 {
            status = "Preparing Food"
        } else if currentStep < 10 {
            status = "Driver Picked Up"
        } else if currentStep < 14 {
            status = "On the Way"
        } else if currentStep < 17 {
            status = "Almost There"
        } else if currentStep < 20 {
            status = "Arriving Soon"
        } else if currentStep >= 20 {
            status = "Delivered"
            isRunning = false
            timer?.invalidate()
            return
        }
        
        // Move delivery location closer to destination for live tracking
        let distanceToDestination = distance(from: pickup, to: current)
        let moveDistance = min(distanceToDestination * 0.3, 300) // Move 30% of remaining distance or max 300m per step
        let newPickup = moveToward(from: pickup, to: current, distance: moveDistance)
        pickupLocation = newPickup
        
        // If very close to destination, snap to it
        if distance(from: newPickup, to: current) < 10 {
            pickupLocation = current
        }
        
        // Force UI update
        objectWillChange.send()
    }
    
    private func moveToward(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, distance: Double) -> CLLocationCoordinate2D {
        let currentDistance = self.distance(from: from, to: to)
        if currentDistance <= distance {
            return to
        }
        
        let fraction = distance / currentDistance
        let lat = from.latitude + (to.latitude - from.latitude) * fraction
        let lon = from.longitude + (to.longitude - from.longitude) * fraction
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    private func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let loc1 = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let loc2 = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return loc1.distance(from: loc2)
    }
    
    func reset() {
        if let current = currentLocation {
            pickupLocation = generateRandomLocation(near: current, maxDistanceMeters: 5000)
        }
        status = "Ready"
        isRunning = false
        currentStep = 0
        timer?.invalidate()
    }
} 
