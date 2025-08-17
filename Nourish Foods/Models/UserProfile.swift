import Foundation
import FirebaseFirestore

struct UserProfile: Codable, Identifiable {
    let id: String // Firebase UID
    var name: String
    var email: String
    var mobile: String
    var profileImageURL: String?
    var dateOfBirth: Date?
    var address: Address?
    var preferences: UserPreferences
    var createdAt: Date
    var updatedAt: Date
    
    struct Address: Codable {
        var street: String
        var city: String
        var postalCode: String
        var country: String
        var isDefault: Bool
        
        var formattedAddress: String {
            return "\(street), \(city) \(postalCode), \(country)"
        }
    }
    
    struct UserPreferences: Codable {
        var dietaryRestrictions: [String]
        var allergies: [String]
        var favoriteCuisines: [String]
        var notificationSettings: NotificationSettings
        
        init() {
            self.dietaryRestrictions = []
            self.allergies = []
            self.favoriteCuisines = []
            self.notificationSettings = NotificationSettings()
        }
    }
    
    struct NotificationSettings: Codable {
        var orderUpdates: Bool = true
        var promotions: Bool = true
        var deliveryAlerts: Bool = true
        var healthTips: Bool = true
    }
    
    init(id: String, name: String, email: String, mobile: String) {
        self.id = id
        self.name = name
        self.email = email
        self.mobile = mobile
        self.profileImageURL = nil
        self.dateOfBirth = nil
        self.address = nil
        self.preferences = UserPreferences()
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

struct UserReview: Codable, Identifiable {
    let id: String
    let userId: String
    let restaurantId: String
    let restaurantName: String
    let rating: Int // 1-5 stars
    let comment: String
    let date: Date
    let orderId: String?
    
    init(userId: String, restaurantId: String, restaurantName: String, rating: Int, comment: String, orderId: String? = nil) {
        self.id = UUID().uuidString
        self.userId = userId
        self.restaurantId = restaurantId
        self.restaurantName = restaurantName
        self.rating = max(1, min(5, rating)) // Ensure rating is between 1-5
        self.comment = comment
        self.date = Date()
        self.orderId = orderId
    }
}

struct UserOrder: Codable, Identifiable {
    let id: String
    let userId: String
    let items: [OrderItem]
    let total: Double
    let deliveryFee: Double
    let status: OrderStatus
    let date: Date
    let deliveryAddress: String?
    let paymentMethod: String?
    let estimatedDeliveryTime: Date?
    let actualDeliveryTime: Date?
    
    enum OrderStatus: String, Codable, CaseIterable {
        case pending = "Pending"
        case confirmed = "Confirmed"
        case preparing = "Preparing"
        case outForDelivery = "Out for Delivery"
        case delivered = "Delivered"
        case cancelled = "Cancelled"
        
        var color: String {
            switch self {
            case .pending: return "orange"
            case .confirmed: return "blue"
            case .preparing: return "purple"
            case .outForDelivery: return "green"
            case .delivered: return "green"
            case .cancelled: return "red"
            }
        }
    }
    
    struct OrderItem: Codable, Identifiable {
        let id: String
        let productId: String
        let productName: String
        let quantity: Int
        let price: Double
        let restaurantName: String
        
        var totalPrice: Double {
            return price * Double(quantity)
        }
    }
    
    init(userId: String, items: [CartItem], total: Double, deliveryFee: Double, deliveryAddress: String? = nil, paymentMethod: String? = nil) {
        self.id = UUID().uuidString
        self.userId = userId
        self.items = items.map { cartItem in
            OrderItem(
                id: UUID().uuidString,
                productId: cartItem.product.id ?? "",
                productName: cartItem.product.shortName,
                quantity: cartItem.quantity,
                price: cartItem.product.price,
                restaurantName: cartItem.product.restaurantName
            )
        }
        self.total = total
        self.deliveryFee = deliveryFee
        self.status = .pending
        self.date = Date()
        self.deliveryAddress = deliveryAddress
        self.paymentMethod = paymentMethod
        self.estimatedDeliveryTime = Calendar.current.date(byAdding: .minute, value: 30, to: Date())
        self.actualDeliveryTime = nil
    }
} 