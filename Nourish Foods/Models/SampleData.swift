import Foundation

struct SampleData {
    
    // MARK: - Sample Restaurants
    
    static let sampleRestaurants: [Restaurant] = [
        Restaurant(
            id: "restaurant_1",
            name: "Burger Palace",
            location: Restaurant.Location(
                latitude: 6.9271,
                longitude: 79.8612,
                address: "123 Galle Road, Colombo 3",
                city: "Colombo",
                postalCode: "00300"
            ),
            contactNumber: "+94 11 234 5678",
            ratings: 4.5,
            totalReviews: 128,
            isOpen: true,
            cuisineType: "Fast Food",
            deliveryRadius: 5.0,
            averageDeliveryTime: 25,
            imageURL: "burger_palace_image",
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        Restaurant(
            id: "restaurant_2",
            name: "Spice Garden",
            location: Restaurant.Location(
                latitude: 6.9271,
                longitude: 79.8612,
                address: "456 Kandy Road, Colombo 4",
                city: "Colombo",
                postalCode: "00400"
            ),
            contactNumber: "+94 11 345 6789",
            ratings: 4.8,
            totalReviews: 95,
            isOpen: true,
            cuisineType: "Sri Lankan",
            deliveryRadius: 4.0,
            averageDeliveryTime: 35,
            imageURL: "spice_garden_image",
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        Restaurant(
            id: "restaurant_3",
            name: "Fresh Juice Bar",
            location: Restaurant.Location(
                latitude: 6.9271,
                longitude: 79.8612,
                address: "789 Marine Drive, Colombo 2",
                city: "Colombo",
                postalCode: "00200"
            ),
            contactNumber: "+94 11 456 7890",
            ratings: 4.2,
            totalReviews: 67,
            isOpen: true,
            cuisineType: "Juices",
            deliveryRadius: 3.0,
            averageDeliveryTime: 15,
            imageURL: "fresh_juice_bar_image",
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        Restaurant(
            id: "restaurant_4",
            name: "Meat Masters",
            location: Restaurant.Location(
                latitude: 6.9271,
                longitude: 79.8612,
                address: "321 Nugegoda Road, Nugegoda",
                city: "Nugegoda",
                postalCode: "10250"
            ),
            contactNumber: "+94 11 567 8901",
            ratings: 4.6,
            totalReviews: 89,
            isOpen: true,
            cuisineType: "Meat Items",
            deliveryRadius: 6.0,
            averageDeliveryTime: 40,
            imageURL: "meat_masters_image",
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        Restaurant(
            id: "restaurant_5",
            name: "Green Leaf Salads",
            location: Restaurant.Location(
                latitude: 6.9271,
                longitude: 79.8612,
                address: "654 Dehiwala Road, Dehiwala",
                city: "Dehiwala",
                postalCode: "10350"
            ),
            contactNumber: "+94 11 678 9012",
            ratings: 4.4,
            totalReviews: 73,
            isOpen: true,
            cuisineType: "Salads",
            deliveryRadius: 4.5,
            averageDeliveryTime: 20,
            imageURL: "green_leaf_salads_image",
            createdAt: Date(),
            updatedAt: Date()
        )
    ]
    
    // MARK: - Sample Food Products
    
    static let sampleFoodProducts: [FoodProduct] = [
        // Burger Palace Products
        FoodProduct(
            id: "product_1",
            shortName: "Classic Burger",
            longName: "Classic Beef Burger with Fries",
            restaurantName: "Burger Palace",
            restaurantId: "restaurant_1",
            price: 850.0,
            productType: .fastFood,
            calories: 650,
            deliveryTime: 25,
            description: "Juicy beef patty with fresh lettuce, tomato, and special sauce. Served with crispy fries.",
            imageURL: "classic_burger_image",
            isAvailable: true,
            allergens: ["Gluten", "Dairy"],
            ingredients: ["Beef patty", "Bun", "Lettuce", "Tomato", "Onion", "Special sauce", "Fries"],
            preparationTime: 8,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_2",
            shortName: "Chicken Burger",
            longName: "Grilled Chicken Burger with Coleslaw",
            restaurantName: "Burger Palace",
            restaurantId: "restaurant_1",
            price: 750.0,
            productType: .fastFood,
            calories: 520,
            deliveryTime: 25,
            description: "Grilled chicken breast with fresh vegetables and creamy coleslaw.",
            imageURL: "chicken_burger_image",
            isAvailable: true,
            allergens: ["Gluten", "Dairy"],
            ingredients: ["Chicken breast", "Bun", "Lettuce", "Tomato", "Coleslaw"],
            preparationTime: 10,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Spice Garden Products
        FoodProduct(
            id: "product_3",
            shortName: "Rice & Curry",
            longName: "Traditional Rice and Curry Platter",
            restaurantName: "Spice Garden",
            restaurantId: "restaurant_2",
            price: 650.0,
            productType: .sriLankan,
            calories: 480,
            deliveryTime: 35,
            description: "Authentic Sri Lankan rice with 3 curries, papadam, and chutney.",
            imageURL: "rice_curry_image",
            isAvailable: true,
            allergens: ["Gluten"],
            ingredients: ["Rice", "Chicken curry", "Dhal curry", "Pumpkin curry", "Papadam", "Chutney"],
            preparationTime: 15,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_4",
            shortName: "Kottu Roti",
            longName: "Chicken Kottu Roti",
            restaurantName: "Spice Garden",
            restaurantId: "restaurant_2",
            price: 550.0,
            productType: .sriLankan,
            calories: 420,
            deliveryTime: 35,
            description: "Shredded roti with chicken, vegetables, and aromatic spices.",
            imageURL: "kottu_roti_image",
            isAvailable: true,
            allergens: ["Gluten"],
            ingredients: ["Roti", "Chicken", "Carrots", "Leeks", "Spices"],
            preparationTime: 12,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Fresh Juice Bar Products
        FoodProduct(
            id: "product_5",
            shortName: "Mango Juice",
            longName: "Fresh Mango Juice",
            restaurantName: "Fresh Juice Bar",
            restaurantId: "restaurant_3",
            price: 250.0,
            productType: .juices,
            calories: 120,
            deliveryTime: 15,
            description: "100% natural mango juice, freshly squeezed.",
            imageURL: "mango_juice_image",
            isAvailable: true,
            allergens: [],
            ingredients: ["Mango"],
            preparationTime: 3,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_6",
            shortName: "Mixed Fruit Juice",
            longName: "Mixed Fruit Juice Blend",
            restaurantName: "Fresh Juice Bar",
            restaurantId: "restaurant_3",
            price: 300.0,
            productType: .juices,
            calories: 140,
            deliveryTime: 15,
            description: "Blend of orange, pineapple, and passion fruit.",
            imageURL: "mixed_fruit_juice_image",
            isAvailable: true,
            allergens: [],
            ingredients: ["Orange", "Pineapple", "Passion fruit"],
            preparationTime: 5,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Meat Masters Products
        FoodProduct(
            id: "product_7",
            shortName: "Grilled Chicken",
            longName: "Grilled Chicken Breast with Herbs",
            restaurantName: "Meat Masters",
            restaurantId: "restaurant_4",
            price: 1200.0,
            productType: .meatItems,
            calories: 380,
            deliveryTime: 40,
            description: "Grilled chicken breast marinated with herbs and spices.",
            imageURL: "grilled_chicken_image",
            isAvailable: true,
            allergens: [],
            ingredients: ["Chicken breast", "Herbs", "Spices", "Olive oil"],
            preparationTime: 20,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_8",
            shortName: "Beef Steak",
            longName: "Grilled Beef Steak with Vegetables",
            restaurantName: "Meat Masters",
            restaurantId: "restaurant_4",
            price: 1800.0,
            productType: .meatItems,
            calories: 520,
            deliveryTime: 40,
            description: "Premium beef steak grilled to perfection with seasonal vegetables.",
            imageURL: "beef_steak_image",
            isAvailable: true,
            allergens: [],
            ingredients: ["Beef steak", "Broccoli", "Carrots", "Potatoes", "Herbs"],
            preparationTime: 25,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Green Leaf Salads Products
        FoodProduct(
            id: "product_9",
            shortName: "Caesar Salad",
            longName: "Classic Caesar Salad",
            restaurantName: "Green Leaf Salads",
            restaurantId: "restaurant_5",
            price: 450.0,
            productType: .salads,
            calories: 280,
            deliveryTime: 20,
            description: "Fresh romaine lettuce with Caesar dressing, croutons, and parmesan cheese.",
            imageURL: "caesar_salad_image",
            isAvailable: true,
            allergens: ["Gluten", "Dairy"],
            ingredients: ["Romaine lettuce", "Caesar dressing", "Croutons", "Parmesan cheese"],
            preparationTime: 8,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_10",
            shortName: "Fruit Salad",
            longName: "Fresh Mixed Fruit Salad",
            restaurantName: "Green Leaf Salads",
            restaurantId: "restaurant_5",
            price: 350.0,
            productType: .fruits,
            calories: 180,
            deliveryTime: 20,
            description: "Seasonal fruits with honey dressing.",
            imageURL: "fruit_salad_image",
            isAvailable: true,
            allergens: [],
            ingredients: ["Apple", "Banana", "Orange", "Pineapple", "Honey"],
            preparationTime: 5,
            createdAt: Date(),
            updatedAt: Date()
        )
    ]
    
    // MARK: - Helper Methods
    
    static func getSampleRestaurant(by id: String) -> Restaurant? {
        return sampleRestaurants.first { $0.id == id }
    }
    
    static func getSampleFoodProducts(by restaurantId: String) -> [FoodProduct] {
        return sampleFoodProducts.filter { $0.restaurantId == restaurantId }
    }
    
    static func getSampleFoodProducts(by productType: FoodProduct.ProductType) -> [FoodProduct] {
        return sampleFoodProducts.filter { $0.productType == productType }
    }
} 