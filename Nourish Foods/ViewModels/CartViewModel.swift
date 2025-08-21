//
//  CartViewModel.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-10.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

@MainActor
class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var isLoading = false
    
    private let userDefaults = UserDefaults.standard
    private let cartKey = "savedCartItems"
    private let ordersKey = "recentOrders"
    @Published var authViewModel: AuthViewModel?
    
    init() {
        loadCartFromStorage()
    }
    
    // Reload cart when authentication state changes
    func reloadCartForUser() {
        loadCartFromStorage()
    }
    
    func addToCart(_ product: FoodProduct, quantity: Int = 1) {
        if let existingIndex = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[existingIndex].quantity += quantity
        } else {
            let newItem = CartItem(product: product, quantity: quantity)
            cartItems.append(newItem)
        }
        saveCartToStorage()
    }
    
    func removeFromCart(_ product: FoodProduct) {
        cartItems.removeAll { $0.product.id == product.id }
        saveCartToStorage()
    }
    
    func updateQuantity(for product: FoodProduct, quantity: Int) {
        guard quantity > 0 else {
            removeFromCart(product)
            return
        }
        
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity = quantity
            saveCartToStorage()
        }
    }
    
    func incrementQuantity(for product: FoodProduct) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += 1
            saveCartToStorage()
        }
    }
    
    func decrementQuantity(for product: FoodProduct) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            if cartItems[index].quantity > 1 {
                cartItems[index].quantity -= 1
            } else {
                removeFromCart(product)
            }
            saveCartToStorage()
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
        saveCartToStorage()
    }
    
    func completeOrder(deliveryAddress: String? = nil, paymentMethod: String? = nil, healthViewModel: HealthTrackingViewModel? = nil, completion: @escaping (Bool) -> Void = { _ in }) {
        // Create UserOrder for authenticated users
        if let authViewModel = authViewModel,
           let userId = authViewModel.currentUser?.uid,
           authViewModel.isAuthenticated {
            let userOrder = UserOrder(
                userId: userId,
                items: cartItems,
                total: totalAmount,
                deliveryFee: deliveryFee,
                deliveryAddress: deliveryAddress,
                paymentMethod: paymentMethod
            )
            
            authViewModel.saveOrder(userOrder) { success in
                DispatchQueue.main.async {
                    if success {
                        // Track calories for health monitoring
                        healthViewModel?.trackPurchase(self.cartItems)
                        self.clearCart()
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            }
        } else {
            // Fallback for non-authenticated users (local storage)
            let order = Order(items: cartItems, total: totalAmount, status: "Delivered")
            saveOrder(order)
            // Track calories for health monitoring
            healthViewModel?.trackPurchase(self.cartItems)
            clearCart()
            completion(true)
        }
    }
    
    private func saveOrder(_ order: Order) {
        var orders = fetchRecentOrders()
        orders.insert(order, at: 0)
        if orders.count > 10 { orders = Array(orders.prefix(10)) }
        if let data = try? JSONEncoder().encode(orders) {
            userDefaults.set(data, forKey: ordersKey)
        }
    }
    
    func fetchRecentOrders() -> [Order] {
        guard let data = userDefaults.data(forKey: ordersKey) else { return [] }
        return (try? JSONDecoder().decode([Order].self, from: data)) ?? []
    }
    
    var totalItems: Int {
        return cartItems.reduce(0) { $0 + $1.quantity }
    }
    
    var subtotal: Double {
        return cartItems.reduce(0) { $0 + $1.totalPrice }
    }
    
    var deliveryFee: Double {
        return cartItems.isEmpty ? 0.0 : 150.0
    }
    
    var totalAmount: Double {
        return subtotal + deliveryFee
    }
    
    // String versions for checkout view
    var subtotalString: String {
        return String(format: "Rs. %.2f", subtotal)
    }
    
    var deliveryFeeString: String {
        return String(format: "Rs. %.2f", deliveryFee)
    }
    
    var totalAmountString: String {
        return String(format: "Rs. %.2f", totalAmount)
    }
    
    var formattedSubtotal: String {
        return String(format: "Rs. %.2f", subtotal)
    }
    
    var formattedDeliveryFee: String {
        return String(format: "Rs. %.2f", deliveryFee)
    }
    
    var formattedTotalAmount: String {
        return String(format: "Rs. %.2f", totalAmount)
    }
    
    var isCartEmpty: Bool {
        return cartItems.isEmpty
    }
    
    // Additional properties for checkout
    var isMultiRestaurantOrder: Bool {
        let restaurantIds = Set(cartItems.map { $0.product.restaurantId })
        return restaurantIds.count > 1
    }
    
    private func saveCartToStorage() {
        // Save to Firebase for authenticated users, fallback to UserDefaults
        if let authViewModel = authViewModel,
           let userId = authViewModel.currentUser?.uid,
           authViewModel.isAuthenticated {
            // Save to Firebase
            saveCartToFirebase(userId: userId)
        } else {
            // Fallback to UserDefaults for non-authenticated users
            do {
                let data = try JSONEncoder().encode(cartItems)
                userDefaults.set(data, forKey: cartKey)
            } catch {
                print("Error saving cart to storage: \(error)")
            }
        }
    }
    
    private func loadCartFromStorage() {
        // Load from Firebase for authenticated users, fallback to UserDefaults
        if let authViewModel = authViewModel,
           let userId = authViewModel.currentUser?.uid,
           authViewModel.isAuthenticated {
            // Load from Firebase
            loadCartFromFirebase(userId: userId)
        } else {
            // Fallback to UserDefaults for non-authenticated users
            guard let data = userDefaults.data(forKey: cartKey) else { return }
            
            do {
                cartItems = try JSONDecoder().decode([CartItem].self, from: data)
            } catch {
                print("Error loading cart from storage: \(error)")
                cartItems = []
            }
        }
    }
    
    private func saveCartToFirebase(userId: String) {
        let db = Firestore.firestore()
        let cartRef = db.collection("users").document(userId).collection("cart")
        
        // Convert cart items to dictionary format
        let cartData = cartItems.map { item in
            [
                "productId": item.product.id,
                "productName": item.product.shortName,
                "productPrice": item.product.price,
                "productImageURL": item.product.imageURL ?? "",
                "restaurantId": item.product.restaurantId,
                "quantity": item.quantity,
                "timestamp": FieldValue.serverTimestamp()
            ]
        }
        
        // Clear existing cart and save new items
        cartRef.getDocuments(source: .default) { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching cart: \(error)")
                return
            }
            
            // Delete existing documents
            let batch = db.batch()
            snapshot?.documents.forEach { document in
                batch.deleteDocument(document.reference)
            }
            
            // Add new items
            cartData.forEach { itemData in
                let docRef = cartRef.document()
                batch.setData(itemData, forDocument: docRef)
            }
            
            // Commit the batch
            batch.commit { error in
                if let error = error {
                    print("Error saving cart to Firebase: \(error)")
                } else {
                    print("Cart saved to Firebase successfully")
                }
            }
        }
    }
    
    private func loadCartFromFirebase(userId: String) {
        let db = Firestore.firestore()
        let cartRef = db.collection("users").document(userId).collection("cart")
        
        cartRef.getDocuments(source: .default) { [weak self] snapshot, error in
            if let error = error {
                print("Error loading cart from Firebase: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No cart documents found")
                return
            }
            
            // Convert Firebase documents back to CartItems
            var loadedItems: [CartItem] = []
            
            for document in documents {
                let data = document.data()
                
                // Build FoodProduct matching its model initializer
                let product = FoodProduct(
                    id: data["productId"] as? String,
                    shortName: data["productName"] as? String ?? "",
                    longName: data["productName"] as? String ?? "",
                    restaurantName: data["restaurantName"] as? String ?? "",
                    restaurantId: data["restaurantId"] as? String ?? "",
                    price: data["productPrice"] as? Double ?? 0.0,
                    productType: FoodProduct.ProductType(rawValue: data["productType"] as? String ?? "") ?? .fastFood,
                    calories: data["calories"] as? Int ?? 0,
                    deliveryTime: data["deliveryTime"] as? Int ?? 0,
                    description: data["description"] as? String ?? "",
                    imageURL: data["productImageURL"] as? String,
                    isAvailable: data["isAvailable"] as? Bool ?? true,
                    allergens: data["allergens"] as? [String] ?? [],
                    ingredients: data["ingredients"] as? [String] ?? [],
                    preparationTime: data["preparationTime"] as? Int ?? 0,
                    createdAt: Date(),
                    updatedAt: Date()
                )
                
                let quantity = data["quantity"] as? Int ?? 1
                let cartItem = CartItem(product: product, quantity: quantity)
                loadedItems.append(cartItem)
            }
            
            self?.cartItems = loadedItems
        }
    }
    
}
