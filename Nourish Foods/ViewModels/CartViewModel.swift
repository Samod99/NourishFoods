//
//  CartViewModel.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-10.
//

import Foundation
import SwiftUI

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
        do {
            let data = try JSONEncoder().encode(cartItems)
            userDefaults.set(data, forKey: cartKey)
        } catch {
            print("Error saving cart to storage: \(error)")
        }
    }
    
    private func loadCartFromStorage() {
        guard let data = userDefaults.data(forKey: cartKey) else { return }
        
        do {
            cartItems = try JSONDecoder().decode([CartItem].self, from: data)
        } catch {
            print("Error loading cart from storage: \(error)")
            cartItems = []
        }
    }
    
}
