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
            imageURL: "burger",
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
            imageURL: "juice",
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
            imageURL: "meat",
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
            imageURL: "fruit",
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        Restaurant(
            id: "restaurant_6",
            name: "Pizza Express",
            location: Restaurant.Location(
                latitude: 6.9271,
                longitude: 79.8612,
                address: "987 Mount Lavinia Road, Mount Lavinia",
                city: "Mount Lavinia",
                postalCode: "10370"
            ),
            contactNumber: "+94 11 789 0123",
            ratings: 4.3,
            totalReviews: 156,
            isOpen: true,
            cuisineType: "Pizza",
            deliveryRadius: 5.5,
            averageDeliveryTime: 30,
            imageURL: "isolated-pizza-with-mushrooms-olives_219193-8149",
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        Restaurant(
            id: "restaurant_7",
            name: "Sweet Treats",
            location: Restaurant.Location(
                latitude: 6.9271,
                longitude: 79.8612,
                address: "147 Battaramulla Road, Battaramulla",
                city: "Battaramulla",
                postalCode: "10120"
            ),
            contactNumber: "+94 11 890 1234",
            ratings: 4.7,
            totalReviews: 89,
            isOpen: true,
            cuisineType: "Desserts",
            deliveryRadius: 4.0,
            averageDeliveryTime: 25,
            imageURL: "fruit",
            createdAt: Date(),
            updatedAt: Date()
        )
    ]
    
    // MARK: - Sample Food Products
    
    static let sampleFoodProducts: [FoodProduct] = [
        // Burger Palace Products (Fast Food)
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
            imageURL: "1",
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
            imageURL: "2",
            isAvailable: true,
            allergens: ["Gluten", "Dairy"],
            ingredients: ["Chicken breast", "Bun", "Lettuce", "Tomato", "Coleslaw"],
            preparationTime: 10,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_3",
            shortName: "Cheese Burger",
            longName: "Double Cheese Burger Deluxe",
            restaurantName: "Burger Palace",
            restaurantId: "restaurant_1",
            price: 950.0,
            productType: .fastFood,
            calories: 780,
            deliveryTime: 25,
            description: "Double beef patty with melted cheese, bacon, and special sauce.",
            imageURL: "3",
            isAvailable: true,
            allergens: ["Gluten", "Dairy"],
            ingredients: ["Beef patty", "Cheese", "Bacon", "Bun", "Lettuce", "Tomato", "Special sauce"],
            preparationTime: 12,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_4",
            shortName: "Veggie Burger",
            longName: "Plant-Based Veggie Burger",
            restaurantName: "Burger Palace",
            restaurantId: "restaurant_1",
            price: 650.0,
            productType: .fastFood,
            calories: 420,
            deliveryTime: 25,
            description: "Plant-based patty with fresh vegetables and vegan mayo.",
            imageURL: "4",
            isAvailable: true,
            allergens: ["Gluten"],
            ingredients: ["Plant-based patty", "Bun", "Lettuce", "Tomato", "Onion", "Vegan mayo"],
            preparationTime: 8,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Spice Garden Products (Sri Lankan)
        FoodProduct(
            id: "product_5",
            shortName: "Rice & Curry",
            longName: "Traditional Rice and Curry Platter",
            restaurantName: "Spice Garden",
            restaurantId: "restaurant_2",
            price: 650.0,
            productType: .sriLankan,
            calories: 480,
            deliveryTime: 35,
            description: "Authentic Sri Lankan rice with 3 curries, papadam, and chutney.",
            imageURL: "5",
            isAvailable: true,
            allergens: ["Gluten"],
            ingredients: ["Rice", "Chicken curry", "Dhal curry", "Pumpkin curry", "Papadam", "Chutney"],
            preparationTime: 15,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_6",
            shortName: "Kottu Roti",
            longName: "Chicken Kottu Roti",
            restaurantName: "Spice Garden",
            restaurantId: "restaurant_2",
            price: 550.0,
            productType: .sriLankan,
            calories: 420,
            deliveryTime: 35,
            description: "Shredded roti with chicken, vegetables, and aromatic spices.",
            imageURL: "6",
            isAvailable: true,
            allergens: ["Gluten"],
            ingredients: ["Roti", "Chicken", "Carrots", "Leeks", "Spices"],
            preparationTime: 12,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_7",
            shortName: "Hoppers",
            longName: "Crispy Hoppers with Curry",
            restaurantName: "Spice Garden",
            restaurantId: "restaurant_2",
            price: 450.0,
            productType: .sriLankan,
            calories: 320,
            deliveryTime: 35,
            description: "Crispy egg hoppers served with spicy curry and chutney.",
            imageURL: "7",
            isAvailable: true,
            allergens: ["Gluten", "Eggs"],
            ingredients: ["Rice flour", "Coconut milk", "Eggs", "Curry", "Chutney"],
            preparationTime: 10,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_8",
            shortName: "String Hoppers",
            longName: "String Hoppers with Dhal",
            restaurantName: "Spice Garden",
            restaurantId: "restaurant_2",
            price: 400.0,
            productType: .sriLankan,
            calories: 280,
            deliveryTime: 35,
            description: "Fresh string hoppers with coconut sambol and dhal curry.",
            imageURL: "8",
            isAvailable: true,
            allergens: ["Gluten"],
            ingredients: ["Rice flour", "Coconut sambol", "Dhal curry"],
            preparationTime: 8,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Fresh Juice Bar Products (Juices)
        FoodProduct(
            id: "product_9",
            shortName: "Mango Juice",
            longName: "Fresh Mango Juice",
            restaurantName: "Fresh Juice Bar",
            restaurantId: "restaurant_3",
            price: 250.0,
            productType: .juices,
            calories: 120,
            deliveryTime: 15,
            description: "100% natural mango juice, freshly squeezed.",
            imageURL: "9",
            isAvailable: true,
            allergens: [],
            ingredients: ["Mango"],
            preparationTime: 3,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_10",
            shortName: "Mixed Fruit Juice",
            longName: "Mixed Fruit Juice Blend",
            restaurantName: "Fresh Juice Bar",
            restaurantId: "restaurant_3",
            price: 300.0,
            productType: .juices,
            calories: 140,
            deliveryTime: 15,
            description: "Blend of orange, pineapple, and passion fruit.",
            imageURL: "10",
            isAvailable: true,
            allergens: [],
            ingredients: ["Orange", "Pineapple", "Passion fruit"],
            preparationTime: 5,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_11",
            shortName: "Pineapple Juice",
            longName: "Fresh Pineapple Juice",
            restaurantName: "Fresh Juice Bar",
            restaurantId: "restaurant_3",
            price: 280.0,
            productType: .juices,
            calories: 130,
            deliveryTime: 15,
            description: "Sweet and tangy pineapple juice, freshly extracted.",
            imageURL: "11",
            isAvailable: true,
            allergens: [],
            ingredients: ["Pineapple"],
            preparationTime: 4,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_12",
            shortName: "Orange Juice",
            longName: "Fresh Orange Juice",
            restaurantName: "Fresh Juice Bar",
            restaurantId: "restaurant_3",
            price: 220.0,
            productType: .juices,
            calories: 110,
            deliveryTime: 15,
            description: "Vitamin C rich orange juice, freshly squeezed.",
            imageURL: "12",
            isAvailable: true,
            allergens: [],
            ingredients: ["Orange"],
            preparationTime: 3,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Meat Masters Products (Meat Items)
        FoodProduct(
            id: "product_13",
            shortName: "Grilled Chicken",
            longName: "Grilled Chicken Breast with Herbs",
            restaurantName: "Meat Masters",
            restaurantId: "restaurant_4",
            price: 1200.0,
            productType: .meatItems,
            calories: 380,
            deliveryTime: 40,
            description: "Grilled chicken breast marinated with herbs and spices.",
            imageURL: "13",
            isAvailable: true,
            allergens: [],
            ingredients: ["Chicken breast", "Herbs", "Spices", "Olive oil"],
            preparationTime: 20,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_14",
            shortName: "Beef Steak",
            longName: "Grilled Beef Steak with Vegetables",
            restaurantName: "Meat Masters",
            restaurantId: "restaurant_4",
            price: 1800.0,
            productType: .meatItems,
            calories: 520,
            deliveryTime: 40,
            description: "Premium beef steak grilled to perfection with seasonal vegetables.",
            imageURL: "14",
            isAvailable: true,
            allergens: [],
            ingredients: ["Beef steak", "Broccoli", "Carrots", "Potatoes", "Herbs"],
            preparationTime: 25,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_15",
            shortName: "Lamb Chops",
            longName: "Grilled Lamb Chops with Mint Sauce",
            restaurantName: "Meat Masters",
            restaurantId: "restaurant_4",
            price: 1600.0,
            productType: .meatItems,
            calories: 450,
            deliveryTime: 40,
            description: "Tender lamb chops grilled with rosemary and served with mint sauce.",
            imageURL: "15",
            isAvailable: true,
            allergens: [],
            ingredients: ["Lamb chops", "Rosemary", "Mint sauce", "Garlic", "Olive oil"],
            preparationTime: 22,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_16",
            shortName: "Pork Ribs",
            longName: "BBQ Pork Ribs with Coleslaw",
            restaurantName: "Meat Masters",
            restaurantId: "restaurant_4",
            price: 1400.0,
            productType: .meatItems,
            calories: 680,
            deliveryTime: 40,
            description: "Slow-cooked pork ribs with BBQ sauce and creamy coleslaw.",
            imageURL: "16",
            isAvailable: true,
            allergens: ["Dairy"],
            ingredients: ["Pork ribs", "BBQ sauce", "Coleslaw", "Spices"],
            preparationTime: 30,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Green Leaf Salads Products (Salads)
        FoodProduct(
            id: "product_17",
            shortName: "Caesar Salad",
            longName: "Classic Caesar Salad",
            restaurantName: "Green Leaf Salads",
            restaurantId: "restaurant_5",
            price: 450.0,
            productType: .salads,
            calories: 280,
            deliveryTime: 20,
            description: "Fresh romaine lettuce with Caesar dressing, croutons, and parmesan cheese.",
            imageURL: "17",
            isAvailable: true,
            allergens: ["Gluten", "Dairy"],
            ingredients: ["Romaine lettuce", "Caesar dressing", "Croutons", "Parmesan cheese"],
            preparationTime: 8,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_18",
            shortName: "Fruit Salad",
            longName: "Fresh Mixed Fruit Salad",
            restaurantName: "Green Leaf Salads",
            restaurantId: "restaurant_5",
            price: 350.0,
            productType: .fruits,
            calories: 180,
            deliveryTime: 20,
            description: "Seasonal fruits with honey dressing.",
            imageURL: "18",
            isAvailable: true,
            allergens: [],
            ingredients: ["Apple", "Banana", "Orange", "Pineapple", "Honey"],
            preparationTime: 5,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_19",
            shortName: "Greek Salad",
            longName: "Mediterranean Greek Salad",
            restaurantName: "Green Leaf Salads",
            restaurantId: "restaurant_5",
            price: 500.0,
            productType: .salads,
            calories: 320,
            deliveryTime: 20,
            description: "Fresh vegetables with feta cheese, olives, and olive oil dressing.",
            imageURL: "19",
            isAvailable: true,
            allergens: ["Dairy"],
            ingredients: ["Cucumber", "Tomatoes", "Red onion", "Feta cheese", "Olives", "Olive oil"],
            preparationTime: 10,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_20",
            shortName: "Quinoa Bowl",
            longName: "Healthy Quinoa Bowl with Avocado",
            restaurantName: "Green Leaf Salads",
            restaurantId: "restaurant_5",
            price: 600.0,
            productType: .salads,
            calories: 420,
            deliveryTime: 20,
            description: "Nutritious quinoa with avocado, cherry tomatoes, and lemon dressing.",
            imageURL: "20",
            isAvailable: true,
            allergens: [],
            ingredients: ["Quinoa", "Avocado", "Cherry tomatoes", "Cucumber", "Lemon dressing"],
            preparationTime: 12,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Pizza Express Products (Pizza)
        FoodProduct(
            id: "product_21",
            shortName: "Margherita Pizza",
            longName: "Classic Margherita Pizza",
            restaurantName: "Pizza Express",
            restaurantId: "restaurant_6",
            price: 1200.0,
            productType: .pizza,
            calories: 850,
            deliveryTime: 30,
            description: "Traditional pizza with tomato sauce, mozzarella, and fresh basil.",
            imageURL: "21",
            isAvailable: true,
            allergens: ["Gluten", "Dairy"],
            ingredients: ["Pizza dough", "Tomato sauce", "Mozzarella", "Basil", "Olive oil"],
            preparationTime: 15,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_22",
            shortName: "Pepperoni Pizza",
            longName: "Spicy Pepperoni Pizza",
            restaurantName: "Pizza Express",
            restaurantId: "restaurant_6",
            price: 1400.0,
            productType: .pizza,
            calories: 920,
            deliveryTime: 30,
            description: "Spicy pepperoni with melted cheese and tomato sauce.",
            imageURL: "22",
            isAvailable: true,
            allergens: ["Gluten", "Dairy"],
            ingredients: ["Pizza dough", "Tomato sauce", "Mozzarella", "Pepperoni"],
            preparationTime: 18,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_23",
            shortName: "Veggie Pizza",
            longName: "Garden Fresh Vegetable Pizza",
            restaurantName: "Pizza Express",
            restaurantId: "restaurant_6",
            price: 1100.0,
            productType: .pizza,
            calories: 780,
            deliveryTime: 30,
            description: "Fresh vegetables with mozzarella and tomato sauce.",
            imageURL: "23",
            isAvailable: true,
            allergens: ["Gluten", "Dairy"],
            ingredients: ["Pizza dough", "Tomato sauce", "Mozzarella", "Bell peppers", "Mushrooms", "Onions"],
            preparationTime: 16,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_24",
            shortName: "BBQ Chicken Pizza",
            longName: "BBQ Chicken Pizza with Red Onions",
            restaurantName: "Pizza Express",
            restaurantId: "restaurant_6",
            price: 1300.0,
            productType: .pizza,
            calories: 890,
            deliveryTime: 30,
            description: "BBQ sauce base with grilled chicken and red onions.",
            imageURL: "24",
            isAvailable: true,
            allergens: ["Gluten", "Dairy"],
            ingredients: ["Pizza dough", "BBQ sauce", "Mozzarella", "Grilled chicken", "Red onions"],
            preparationTime: 20,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Sweet Treats Products (Desserts)
        FoodProduct(
            id: "product_25",
            shortName: "Chocolate Cake",
            longName: "Rich Chocolate Layer Cake",
            restaurantName: "Sweet Treats",
            restaurantId: "restaurant_7",
            price: 450.0,
            productType: .desserts,
            calories: 380,
            deliveryTime: 25,
            description: "Decadent chocolate cake with chocolate ganache frosting.",
            imageURL: "25",
            isAvailable: true,
            allergens: ["Gluten", "Dairy", "Eggs"],
            ingredients: ["Chocolate", "Flour", "Sugar", "Eggs", "Butter", "Cream"],
            preparationTime: 10,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_26",
            shortName: "Cheesecake",
            longName: "New York Style Cheesecake",
            restaurantName: "Sweet Treats",
            restaurantId: "restaurant_7",
            price: 500.0,
            productType: .desserts,
            calories: 420,
            deliveryTime: 25,
            description: "Creamy cheesecake with graham cracker crust and berry compote.",
            imageURL: "26",
            isAvailable: true,
            allergens: ["Gluten", "Dairy", "Eggs"],
            ingredients: ["Cream cheese", "Graham crackers", "Sugar", "Eggs", "Berries"],
            preparationTime: 12,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_27",
            shortName: "Ice Cream",
            longName: "Vanilla Bean Ice Cream",
            restaurantName: "Sweet Treats",
            restaurantId: "restaurant_7",
            price: 300.0,
            productType: .desserts,
            calories: 280,
            deliveryTime: 25,
            description: "Creamy vanilla bean ice cream with chocolate chips.",
            imageURL: "27",
            isAvailable: true,
            allergens: ["Dairy", "Eggs"],
            ingredients: ["Cream", "Milk", "Vanilla beans", "Sugar", "Chocolate chips"],
            preparationTime: 5,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_28",
            shortName: "Tiramisu",
            longName: "Classic Italian Tiramisu",
            restaurantName: "Sweet Treats",
            restaurantId: "restaurant_7",
            price: 550.0,
            productType: .desserts,
            calories: 350,
            deliveryTime: 25,
            description: "Coffee-flavored Italian dessert with mascarpone cream.",
            imageURL: "28",
            isAvailable: true,
            allergens: ["Gluten", "Dairy", "Eggs"],
            ingredients: ["Ladyfingers", "Mascarpone", "Coffee", "Cocoa powder", "Eggs"],
            preparationTime: 15,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Additional Fast Food Items
        FoodProduct(
            id: "product_29",
            shortName: "Chicken Wings",
            longName: "Crispy Buffalo Chicken Wings",
            restaurantName: "Burger Palace",
            restaurantId: "restaurant_1",
            price: 800.0,
            productType: .fastFood,
            calories: 650,
            deliveryTime: 25,
            description: "Crispy chicken wings tossed in buffalo sauce with ranch dip.",
            imageURL: "29",
            isAvailable: true,
            allergens: ["Gluten", "Dairy"],
            ingredients: ["Chicken wings", "Buffalo sauce", "Ranch dip", "Celery sticks"],
            preparationTime: 15,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_30",
            shortName: "Fish & Chips",
            longName: "Crispy Fish and Chips",
            restaurantName: "Burger Palace",
            restaurantId: "restaurant_1",
            price: 900.0,
            productType: .fastFood,
            calories: 720,
            deliveryTime: 25,
            description: "Beer-battered fish fillet with crispy fries and tartar sauce.",
            imageURL: "30",
            isAvailable: true,
            allergens: ["Gluten", "Fish"],
            ingredients: ["Fish fillet", "Beer batter", "Fries", "Tartar sauce", "Lemon"],
            preparationTime: 18,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Additional Sri Lankan Items
        FoodProduct(
            id: "product_31",
            shortName: "Lamprais",
            longName: "Traditional Dutch Lamprais",
            restaurantName: "Spice Garden",
            restaurantId: "restaurant_2",
            price: 750.0,
            productType: .sriLankan,
            calories: 580,
            deliveryTime: 35,
            description: "Rice, meat, and vegetables wrapped in banana leaf and baked.",
            imageURL: "31",
            isAvailable: true,
            allergens: ["Gluten"],
            ingredients: ["Rice", "Chicken", "Curry", "Banana leaf", "Spices"],
            preparationTime: 25,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_32",
            shortName: "Crab Curry",
            longName: "Spicy Crab Curry with Rice",
            restaurantName: "Spice Garden",
            restaurantId: "restaurant_2",
            price: 850.0,
            productType: .sriLankan,
            calories: 420,
            deliveryTime: 35,
            description: "Fresh crab cooked in aromatic spices with coconut milk.",
            imageURL: "32",
            isAvailable: true,
            allergens: ["Shellfish"],
            ingredients: ["Crab", "Coconut milk", "Spices", "Rice", "Curry leaves"],
            preparationTime: 20,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Additional Juice Items
        FoodProduct(
            id: "product_33",
            shortName: "Watermelon Juice",
            longName: "Refreshing Watermelon Juice",
            restaurantName: "Fresh Juice Bar",
            restaurantId: "restaurant_3",
            price: 200.0,
            productType: .juices,
            calories: 90,
            deliveryTime: 15,
            description: "Sweet and hydrating watermelon juice, perfect for hot days.",
            imageURL: "33",
            isAvailable: true,
            allergens: [],
            ingredients: ["Watermelon"],
            preparationTime: 3,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        FoodProduct(
            id: "product_34",
            shortName: "Strawberry Smoothie",
            longName: "Creamy Strawberry Smoothie",
            restaurantName: "Fresh Juice Bar",
            restaurantId: "restaurant_3",
            price: 350.0,
            productType: .juices,
            calories: 180,
            deliveryTime: 15,
            description: "Blended strawberry smoothie with yogurt and honey.",
            imageURL: "34",
            isAvailable: true,
            allergens: ["Dairy"],
            ingredients: ["Strawberries", "Yogurt", "Honey", "Milk"],
            preparationTime: 6,
            createdAt: Date(),
            updatedAt: Date()
        ),
        
        // Additional Meat Items
        FoodProduct(
            id: "product_35",
            shortName: "Turkey Breast",
            longName: "Herb-Roasted Turkey Breast",
            restaurantName: "Meat Masters",
            restaurantId: "restaurant_4",
            price: 1100.0,
            productType: .meatItems,
            calories: 320,
            deliveryTime: 40,
            description: "Lean turkey breast roasted with herbs and served with cranberry sauce.",
            imageURL: "35",
            isAvailable: true,
            allergens: [],
            ingredients: ["Turkey breast", "Herbs", "Cranberry sauce", "Garlic", "Olive oil"],
            preparationTime: 18,
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
