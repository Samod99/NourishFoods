import Foundation
import FirebaseFirestore

class FirestoreService: ObservableObject {
    private let db = Firestore.firestore()
    
    // MARK: - Restaurant Operations
    
    func fetchRestaurants() async throws -> [Restaurant] {
        let snapshot = try await db.collection(Restaurant.collectionName).getDocuments()
        return snapshot.documents.compactMap { Restaurant.fromFirestore($0) }
    }
    
    func fetchRestaurant(by id: String) async throws -> Restaurant? {
        let document = try await db.collection(Restaurant.collectionName).document(id).getDocument()
        return Restaurant.fromFirestore(document)
    }
    
    func fetchRestaurants(by cuisineType: String) async throws -> [Restaurant] {
        let snapshot = try await db.collection(Restaurant.collectionName)
            .whereField("cuisineType", isEqualTo: cuisineType)
            .getDocuments()
        return snapshot.documents.compactMap { Restaurant.fromFirestore($0) }
    }
    
    func fetchOpenRestaurants() async throws -> [Restaurant] {
        let snapshot = try await db.collection(Restaurant.collectionName)
            .whereField("isOpen", isEqualTo: true)
            .getDocuments()
        return snapshot.documents.compactMap { Restaurant.fromFirestore($0) }
    }
    
    func addRestaurant(_ restaurant: Restaurant) async throws -> String {
        let docRef = try await db.collection(Restaurant.collectionName).addDocument(data: restaurant.toFirestore())
        return docRef.documentID
    }
    
    func updateRestaurant(_ restaurant: Restaurant) async throws {
        guard let id = restaurant.id else { throw FirestoreError.invalidDocumentID }
        try await db.collection(Restaurant.collectionName).document(id).setData(restaurant.toFirestore())
    }
    
    func deleteRestaurant(id: String) async throws {
        try await db.collection(Restaurant.collectionName).document(id).delete()
    }
    
    // MARK: - Food Product Operations
    
    func fetchFoodProducts() async throws -> [FoodProduct] {
        let snapshot = try await db.collection(FoodProduct.collectionName).getDocuments()
        return snapshot.documents.compactMap { FoodProduct.fromFirestore($0) }
    }
    
    func fetchFoodProduct(by id: String) async throws -> FoodProduct? {
        let document = try await db.collection(FoodProduct.collectionName).document(id).getDocument()
        return FoodProduct.fromFirestore(document)
    }
    
    func fetchFoodProducts(by restaurantId: String) async throws -> [FoodProduct] {
        let snapshot = try await db.collection(FoodProduct.collectionName)
            .whereField("restaurantId", isEqualTo: restaurantId)
            .getDocuments()
        return snapshot.documents.compactMap { FoodProduct.fromFirestore($0) }
    }
    
    func fetchFoodProducts(by productType: FoodProduct.ProductType) async throws -> [FoodProduct] {
        let snapshot = try await db.collection(FoodProduct.collectionName)
            .whereField("productType", isEqualTo: productType.rawValue)
            .whereField("isAvailable", isEqualTo: true)
            .getDocuments()
        return snapshot.documents.compactMap { FoodProduct.fromFirestore($0) }
    }
    
    func fetchAvailableFoodProducts() async throws -> [FoodProduct] {
        let snapshot = try await db.collection(FoodProduct.collectionName)
            .whereField("isAvailable", isEqualTo: true)
            .getDocuments()
        return snapshot.documents.compactMap { FoodProduct.fromFirestore($0) }
    }
    
    func searchFoodProducts(query: String) async throws -> [FoodProduct] {
        let snapshot = try await db.collection(FoodProduct.collectionName)
            .whereField("isAvailable", isEqualTo: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { FoodProduct.fromFirestore($0) }
            .filter { product in
                product.shortName.localizedCaseInsensitiveContains(query) ||
                product.longName.localizedCaseInsensitiveContains(query) ||
                product.restaurantName.localizedCaseInsensitiveContains(query) ||
                product.description.localizedCaseInsensitiveContains(query)
            }
    }
    
    func addFoodProduct(_ foodProduct: FoodProduct) async throws -> String {
        let docRef = try await db.collection(FoodProduct.collectionName).addDocument(data: foodProduct.toFirestore())
        return docRef.documentID
    }
    
    func updateFoodProduct(_ foodProduct: FoodProduct) async throws {
        guard let id = foodProduct.id else { throw FirestoreError.invalidDocumentID }
        try await db.collection(FoodProduct.collectionName).document(id).setData(foodProduct.toFirestore())
    }
    
    func deleteFoodProduct(id: String) async throws {
        try await db.collection(FoodProduct.collectionName).document(id).delete()
    }
    
    // MARK: - Combined Operations
    
    func fetchRestaurantWithProducts(restaurantId: String) async throws -> (Restaurant?, [FoodProduct]) {
        async let restaurant = fetchRestaurant(by: restaurantId)
        async let products = fetchFoodProducts(by: restaurantId)
        
        let (restaurantResult, productsResult) = try await (restaurant, products)
        return (restaurantResult, productsResult)
    }
    
    func calculateDeliveryTime(for foodProduct: FoodProduct, userLocation: Restaurant.Location) async throws -> Int {
        guard let restaurant = try await fetchRestaurant(by: foodProduct.restaurantId) else {
            return foodProduct.deliveryTime
        }
        
        // Calculate distance between user and restaurant
        let distance = calculateDistance(
            from: userLocation,
            to: restaurant.location
        )
        
        // Base delivery time + distance factor + preparation time
        let baseDeliveryTime = restaurant.averageDeliveryTime
        let distanceFactor = Int(distance * 2) // 2 minutes per km
        let preparationTime = foodProduct.preparationTime
        
        return baseDeliveryTime + distanceFactor + preparationTime
    }
    
    // MARK: - Helper Methods
    
    private func calculateDistance(from location1: Restaurant.Location, to location2: Restaurant.Location) -> Double {
        let lat1 = location1.latitude
        let lon1 = location1.longitude
        let lat2 = location2.latitude
        let lon2 = location2.longitude
        
        let R = 6371.0
        let dLat = (lat2 - lat1) * .pi / 180
        let dLon = (lon2 - lon1) * .pi / 180
        let a = sin(dLat/2) * sin(dLat/2) + cos(lat1 * .pi / 180) * cos(lat2 * .pi / 180) * sin(dLon/2) * sin(dLon/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        return R * c
    }
    
    // MARK: - Sample Data Initialization
    
    /// Checks if Firebase collections are empty and populates them with sample data
    func initializeSampleDataIfNeeded() async throws {
        // Check restaurants collection
        let restaurantSnapshot = try await db.collection(Restaurant.collectionName).getDocuments()
        if restaurantSnapshot.documents.isEmpty {
            print("No restaurants found. Adding sample restaurants...")
            try await addSampleRestaurants()
        }
        
        // Check food products collection
        let productSnapshot = try await db.collection(FoodProduct.collectionName).getDocuments()
        if productSnapshot.documents.isEmpty {
            print("No food products found. Adding sample food products...")
            try await addSampleFoodProducts()
        }
    }
    
    /// Adds sample restaurants to Firebase
    private func addSampleRestaurants() async throws {
        for restaurant in SampleData.sampleRestaurants {
            // Create restaurant without ID (Firestore will assign one)
            let restaurantWithoutId = Restaurant(
                id: nil,
                name: restaurant.name,
                location: restaurant.location,
                contactNumber: restaurant.contactNumber,
                ratings: restaurant.ratings,
                totalReviews: restaurant.totalReviews,
                isOpen: restaurant.isOpen,
                cuisineType: restaurant.cuisineType,
                deliveryRadius: restaurant.deliveryRadius,
                averageDeliveryTime: restaurant.averageDeliveryTime,
                imageURL: restaurant.imageURL,
                createdAt: restaurant.createdAt,
                updatedAt: restaurant.updatedAt
            )
            
            let _ = try await addRestaurant(restaurantWithoutId)
        }
        print("✅ Sample restaurants added successfully")
    }
    
    /// Adds sample food products to Firebase
    private func addSampleFoodProducts() async throws {
        // First, get all restaurants to map restaurant names to IDs
        let restaurants = try await fetchRestaurants()
        var restaurantNameToId: [String: String] = [:]
        
        for restaurant in restaurants {
            restaurantNameToId[restaurant.name] = restaurant.id
        }
        
        for product in SampleData.sampleFoodProducts {
            // Find the restaurant ID for this product
            guard let restaurantId = restaurantNameToId[product.restaurantName] else {
                print("⚠️ Restaurant not found for product: \(product.shortName)")
                continue
            }
            
            // Create product without ID and with correct restaurant ID
            let productWithoutId = FoodProduct(
                id: nil,
                shortName: product.shortName,
                longName: product.longName,
                restaurantName: product.restaurantName,
                restaurantId: restaurantId,
                price: product.price,
                productType: product.productType,
                calories: product.calories,
                deliveryTime: product.deliveryTime,
                description: product.description,
                imageURL: product.imageURL,
                isAvailable: product.isAvailable,
                allergens: product.allergens,
                ingredients: product.ingredients,
                preparationTime: product.preparationTime,
                createdAt: product.createdAt,
                updatedAt: product.updatedAt
            )
            
            let _ = try await addFoodProduct(productWithoutId)
        }
        print("✅ Sample food products added successfully")
    }
    
    /// Resets all data and reinitializes with sample data
    func resetToSampleData() async throws {
        print("🔄 Resetting all data and adding sample data...")
        
        // Delete all existing data
        try await deleteAllData()
        
        // Add sample data
        try await addSampleRestaurants()
        try await addSampleFoodProducts()
        
        print("✅ Data reset completed successfully")
    }
    
    /// Deletes all restaurants and food products
    private func deleteAllData() async throws {
        // Delete all restaurants
        let restaurantSnapshot = try await db.collection(Restaurant.collectionName).getDocuments()
        for document in restaurantSnapshot.documents {
            try await db.collection(Restaurant.collectionName).document(document.documentID).delete()
        }
        
        // Delete all food products
        let productSnapshot = try await db.collection(FoodProduct.collectionName).getDocuments()
        for document in productSnapshot.documents {
            try await db.collection(FoodProduct.collectionName).document(document.documentID).delete()
        }
        
        print("🗑️ All existing data deleted")
    }
}

// MARK: - Error Types
enum FirestoreError: Error, LocalizedError {
    case invalidDocumentID
    case documentNotFound
    case networkError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidDocumentID:
            return "Invalid document ID"
        case .documentNotFound:
            return "Document not found"
        case .networkError:
            return "Network error occurred"
        case .unknownError:
            return "An unknown error occurred"
        }
    }
} 
