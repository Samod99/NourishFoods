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
