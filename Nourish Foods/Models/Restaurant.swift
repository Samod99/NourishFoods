import Foundation
import FirebaseFirestore

struct Restaurant: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let location: Location
    let contactNumber: String
    let ratings: Double
    let totalReviews: Int
    let isOpen: Bool
    let cuisineType: String
    let deliveryRadius: Double // in kilometers
    let averageDeliveryTime: Int // in minutes
    let imageURL: String?
    let createdAt: Date
    let updatedAt: Date
    
    struct Location: Codable {
        let latitude: Double
        let longitude: Double
        let address: String
        let city: String
        let postalCode: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
        case contactNumber
        case ratings
        case totalReviews
        case isOpen
        case cuisineType
        case deliveryRadius
        case averageDeliveryTime
        case imageURL
        case createdAt
        case updatedAt
    }
}

// MARK: - Firestore Extensions
extension Restaurant {
    static let collectionName = "restaurants"
    
    func toFirestore() -> [String: Any] {
        return [
            "name": name,
            "location": [
                "latitude": location.latitude,
                "longitude": location.longitude,
                "address": location.address,
                "city": location.city,
                "postalCode": location.postalCode
            ],
            "contactNumber": contactNumber,
            "ratings": ratings,
            "totalReviews": totalReviews,
            "isOpen": isOpen,
            "cuisineType": cuisineType,
            "deliveryRadius": deliveryRadius,
            "averageDeliveryTime": averageDeliveryTime,
            "imageURL": imageURL as Any,
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt)
        ]
    }
    
    static func fromFirestore(_ document: DocumentSnapshot) -> Restaurant? {
        guard let data = document.data() else { return nil }
        
        let locationData = data["location"] as? [String: Any] ?? [:]
        let location = Location(
            latitude: locationData["latitude"] as? Double ?? 0.0,
            longitude: locationData["longitude"] as? Double ?? 0.0,
            address: locationData["address"] as? String ?? "",
            city: locationData["city"] as? String ?? "",
            postalCode: locationData["postalCode"] as? String ?? ""
        )
        
        return Restaurant(
            id: document.documentID,
            name: data["name"] as? String ?? "",
            location: location,
            contactNumber: data["contactNumber"] as? String ?? "",
            ratings: data["ratings"] as? Double ?? 0.0,
            totalReviews: data["totalReviews"] as? Int ?? 0,
            isOpen: data["isOpen"] as? Bool ?? false,
            cuisineType: data["cuisineType"] as? String ?? "",
            deliveryRadius: data["deliveryRadius"] as? Double ?? 0.0,
            averageDeliveryTime: data["averageDeliveryTime"] as? Int ?? 0,
            imageURL: data["imageURL"] as? String,
            createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
            updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
        )
    }
} 
