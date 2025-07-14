import Foundation
import CoreLocation
import Combine

class DemoMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var deliveryLocation: CLLocationCoordinate2D? // User-selected delivery address
    @Published var status: String = "Ready"
    @Published var isRunning: Bool = false
    @Published var currentStep = 0

    
    private let locationManager = CLLocationManager()
    private var timer: Timer?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.last {
            currentLocation = loc.coordinate
            // If delivery location is not set, default to current location
            if deliveryLocation == nil {
                deliveryLocation = loc.coordinate
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Fallback to mock location (Colombo)
        let mock = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
        currentLocation = mock
        if deliveryLocation == nil {
            deliveryLocation = mock
        }
    }
    
    func setDeliveryLocation(_ coordinate: CLLocationCoordinate2D) {
        deliveryLocation = coordinate
    }
    
    func startDemo() {
        // Ensure we have locations to work with
        if currentLocation == nil {
            let mock = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
            currentLocation = mock
        }
        if deliveryLocation == nil {
            deliveryLocation = currentLocation
        }
        isRunning = true
        status = "Order Confirmed"
        currentStep = 0
        timer?.invalidate()
        // Complete demo in 20 seconds: 20 steps * 1 second = 20 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] t in
            self?.moveDeliveryCloser()
        }
    }
    
    private func moveDeliveryCloser() {
        // Ensure we have valid locations
        guard let current = currentLocation, let delivery = deliveryLocation else { return }
        
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
        let distanceToDestination = distance(from: delivery, to: current)
        let moveDistance = min(distanceToDestination * 0.3, 300) // Move 30% of remaining distance or max 300m per step
        let newDelivery = moveToward(from: delivery, to: current, distance: moveDistance)
        deliveryLocation = newDelivery
        
        // If very close to destination, snap to it
        if distance(from: newDelivery, to: current) < 10 {
            deliveryLocation = current
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
            deliveryLocation = current
        }
        status = "Ready"
        isRunning = false
        currentStep = 0
        timer?.invalidate()
    }
} 
