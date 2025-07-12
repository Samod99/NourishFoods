import Foundation
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [FoodProduct] = []
    @Published var allProducts: [FoodProduct] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCategory: FoodProduct.ProductType?
    
    private let firestoreService = FirestoreService()
    
    // All available product types for filtering
    let allProductTypes = FoodProduct.ProductType.allCases
    
    init() {
        Task {
            await loadAllProducts()
        }
    }
    
    func loadAllProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            allProducts = try await firestoreService.fetchAvailableFoodProducts()
            searchResults = allProducts
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            print("❌ Error loading products: \(error)")
        }
        
        isLoading = false
    }
    
    func searchProducts() {
        guard !searchText.isEmpty else {
            searchResults = allProducts
            return
        }
        
        searchResults = allProducts.filter { product in
            product.shortName.localizedCaseInsensitiveContains(searchText) ||
            product.longName.localizedCaseInsensitiveContains(searchText) ||
            product.restaurantName.localizedCaseInsensitiveContains(searchText) ||
            product.description.localizedCaseInsensitiveContains(searchText) ||
            product.productType.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func filterByCategory(_ category: FoodProduct.ProductType?) {
        selectedCategory = category
        
        if let category = category {
            searchResults = allProducts.filter { $0.productType == category }
        } else {
            searchResults = allProducts
        }
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategory = nil
        searchResults = allProducts
    }
    
    func refreshData() async {
        await loadAllProducts()
    }
} 