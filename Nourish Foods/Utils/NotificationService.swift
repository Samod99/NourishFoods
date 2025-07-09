import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    private init() {}
    
    func requestPermission(completion: ((Bool) -> Void)? = nil) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion?(granted)
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
    
    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
} 