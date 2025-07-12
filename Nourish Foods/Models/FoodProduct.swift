import Foundation
import FirebaseFirestore

struct FoodProduct: Identifiable, Codable {
    @DocumentID var id: String?
    let shortName: String
    let longName: String
    let restaurantName: String
    let restaurantId: String
    let price: Double
    let productType: ProductType
    let calories: Int
    let deliveryTime: Int // in minutes
    let description: String
    let imageURL: String?
    let isAvailable: Bool
    let allergens: [String]
    let ingredients: [String]
    let preparationTime: Int // in minutes
    let createdAt: Date
    let updatedAt: Date
    
    enum ProductType: String, CaseIterable, Codable {
        case fastFood = "Fast Food"
        case sriLankan = "Sri Lankan"
        case juices = "Juices"
        case meatItems = "Meat Items"
        case salads = "Salads"
        case fruits = "Fruits"
        case desserts = "Desserts"
        case beverages = "Beverages"
        case snacks = "Snacks"
        case vegetarian = "Vegetarian"
        case seafood = "Seafood"
        case pasta = "Pasta"
        case pizza = "Pizza"
        case sandwiches = "Sandwiches"
        case soups = "Soups"
        
        var displayName: String {
            return self.rawValue
        }
        
        var icon: String {
            switch self {
            case .fastFood: return "🍔"
            case .sriLankan: return "🍛"
            case .juices: return "🥤"
            case .meatItems: return "🥩"
            case .salads: return "🥗"
            case .fruits: return "🍎"
            case .desserts: return "🍰"
            case .beverages: return "☕"
            case .snacks: return "🍿"
            case .vegetarian: return "🥬"
            case .seafood: return "🐟"
            case .pasta: return "🍝"
            case .pizza: return "🍕"
            case .sandwiches: return "🥪"
            case .soups: return "🍲"
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case shortName
        case longName
        case restaurantName
        case restaurantId
        case price
        case productType
        case calories
        case deliveryTime
        case description
        case imageURL
        case isAvailable
        case allergens
        case ingredients
        case preparationTime
        case createdAt
        case updatedAt
    }
}

// MARK: - Firestore Extensions
extension FoodProduct {
    static let collectionName = "foodProducts"
    
    func toFirestore() -> [String: Any] {
        return [
            "shortName": shortName,
            "longName": longName,
            "restaurantName": restaurantName,
            "restaurantId": restaurantId,
            "price": price,
            "productType": productType.rawValue,
            "calories": calories,
            "deliveryTime": deliveryTime,
            "description": description,
            "imageURL": imageURL as Any,
            "isAvailable": isAvailable,
            "allergens": allergens,
            "ingredients": ingredients,
            "preparationTime": preparationTime,
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt)
        ]
    }
    
    static func fromFirestore(_ document: DocumentSnapshot) -> FoodProduct? {
        guard let data = document.data() else { return nil }
        
        let productTypeString = data["productType"] as? String ?? ""
        let productType = ProductType(rawValue: productTypeString) ?? .fastFood
        
        return FoodProduct(
            id: document.documentID,
            shortName: data["shortName"] as? String ?? "",
            longName: data["longName"] as? String ?? "",
            restaurantName: data["restaurantName"] as? String ?? "",
            restaurantId: data["restaurantId"] as? String ?? "",
            price: data["price"] as? Double ?? 0.0,
            productType: productType,
            calories: data["calories"] as? Int ?? 0,
            deliveryTime: data["deliveryTime"] as? Int ?? 0,
            description: data["description"] as? String ?? "",
            imageURL: data["imageURL"] as? String,
            isAvailable: data["isAvailable"] as? Bool ?? false,
            allergens: data["allergens"] as? [String] ?? [],
            ingredients: data["ingredients"] as? [String] ?? [],
            preparationTime: data["preparationTime"] as? Int ?? 0,
            createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
            updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
        )
    }
}

// MARK: - Helper Methods
extension FoodProduct {
    var formattedPrice: String {
        return String(format: "Rs. %.2f", price)
    }
    
    var formattedDeliveryTime: String {
        if deliveryTime < 60 {
            return "\(deliveryTime) min"
        } else {
            let hours = deliveryTime / 60
            let minutes = deliveryTime % 60
            return minutes > 0 ? "\(hours)h \(minutes)m" : "\(hours)h"
        }
    }
    
    var formattedCalories: String {
        return "\(calories) cal"
    }
} 
