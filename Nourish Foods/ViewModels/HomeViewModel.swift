import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var healthyFoods: [FoodProduct] = []
    @Published var bestSalesProducts: [FoodProduct] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let firestoreService = FirestoreService()
    
    // Category data for the category cards
    let categories = [
        (imageName: "meat", title: "Meat", productType: FoodProduct.ProductType.meatItems),
        (imageName: "burger", title: "Fast Food", productType: FoodProduct.ProductType.fastFood),
        (imageName: "fruit", title: "Fruits", productType: FoodProduct.ProductType.fruits),
        (imageName: "juice", title: "Juice", productType: FoodProduct.ProductType.juices)
    ]
    
    init() {
        Task {
            await loadHomeData()
        }
    }
    
    func loadHomeData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let allProducts = try await firestoreService.fetchAvailableFoodProducts()
            healthyFoods = allProducts.filter { [.vegetarian, .salads, .fruits, .soups].contains($0.productType) }.prefix(6).map { $0 }
            bestSalesProducts = allProducts
                .sorted { $0.calories > $1.calories }
                .prefix(6)
                .map { $0 }
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
            print("Error loading home data: \(error)")
        }
        
        isLoading = false
    }
    
    func refreshData() async {
        await loadHomeData()
    }
    
    // Get products by category
    func getProductsByCategory(_ productType: FoodProduct.ProductType) async -> [FoodProduct] {
        do {
            return try await firestoreService.fetchFoodProducts(by: productType)
        } catch {
            print("Error loading products for category \(productType): \(error)")
            return []
        }
    }
} 