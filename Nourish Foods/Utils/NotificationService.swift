import Foundation
import UserNotifications
import SwiftUI

class NotificationService {
    static let shared = NotificationService()
    private init() {}
    
    var showInAppAlert: ((String, String) -> Void)?
    
    func requestPermission(completion: ((Bool) -> Void)? = nil) {
        print(" Requesting notification permission...")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Notification permission error: \(error.localizedDescription)")
                }
                print(" Permission granted: \(granted)")
                completion?(granted)
            }
        }
    }
    
    func checkPermissionStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                print(" Current notification status: \(settings.authorizationStatus.rawValue)")
                completion(settings.authorizationStatus)
            }
        }
    }
    
    func sendPromotionalNotification() {
        sendNotification(title: "Special Offer!", body: "Check out our latest promotions and discounts.")
    }
    
    func sendDeliveryUpdateNotification(start: Bool) {
        let title = "Delivery Update"
        let body = start ? "Your delivery is on the way!" : "Your delivery has arrived. Enjoy your meal!"
        sendNotification(title: title, body: body)
    }
    
    func sendOrderUpdateNotification(placed: Bool) {
        let title = "Order Update"
        let body = placed ? "Your order has been placed successfully!" : "Thank you for your order!"
        sendNotification(title: title, body: body)
    }
    
    func sendAddToCartNotification(item: String) {
        let title = "Cart Added"
        let body = "\(item) is added to cart successfully"
        sendNotification(title: title, body: body)
    }
    
    func sendTestNotification() {
        sendNotification(title: "Test Notification", body: "This is a test notification to verify the system is working.")
    }
    
    private func sendNotification(title: String, body: String) {
        // First check if we have permission
        checkPermissionStatus { status in
            switch status {
            case .authorized, .provisional, .ephemeral:
                print("Permission granted, creating notification...")
                self.createAndSendNotification(title: title, body: body)
            case .denied:
                print("Notification permission denied")
                // Show in-app alert if permission denied
                self.showInAppAlert?(title, body)
            case .notDetermined:
                print("Notification permission not determined")
                // Request permission and then send notification
                self.requestPermission { granted in
                    if granted {
                        print("Permission granted after request, creating notification...")
                        self.createAndSendNotification(title: title, body: body)
                    } else {
                        print("Permission denied after request")
                        // Show in-app alert if permission denied
                        self.showInAppAlert?(title, body)
                    }
                }
            @unknown default:
                print("Unknown notification authorization status")
            }
        }
    }
    
    private func createAndSendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        print("Adding notification request: \(title)")
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send notification: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.showInAppAlert?(title, body)
                }
            } else {
                print("Notification sent successfully: \(title)")
            }
        }
    }
} 
