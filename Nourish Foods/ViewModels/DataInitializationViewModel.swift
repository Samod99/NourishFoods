import Foundation
import SwiftUI

@MainActor
class DataInitializationViewModel: ObservableObject {
    @Published var isInitializing = false
    @Published var initializationMessage = ""
    @Published var hasInitialized = false
    
    private let firestoreService = FirestoreService()
    
    /// Initialize sample data if Firebase collections are empty
    func initializeSampleDataIfNeeded() async {
        guard !hasInitialized else { return }
        
        isInitializing = true
        initializationMessage = "Checking database..."
        
        do {
            try await firestoreService.initializeSampleDataIfNeeded()
            hasInitialized = true
            initializationMessage = "Database ready!"
        } catch {
            initializationMessage = "Error initializing data: \(error.localizedDescription)"
            print("❌ Error initializing sample data: \(error)")
        }
        
        isInitializing = false
    }
    
    /// Force reset all data and reinitialize with sample data
    func resetToSampleData() async {
        isInitializing = true
        initializationMessage = "Resetting database..."
        
        do {
            try await firestoreService.resetToSampleData()
            hasInitialized = true
            initializationMessage = "Database reset successfully!"
        } catch {
            initializationMessage = "Error resetting data: \(error.localizedDescription)"
            print("❌ Error resetting data: \(error)")
        }
        
        isInitializing = false
    }
    
    /// Check if database has data
    func checkDatabaseStatus() async -> (hasRestaurants: Bool, hasProducts: Bool) {
        do {
            let restaurants = try await firestoreService.fetchRestaurants()
            let products = try await firestoreService.fetchFoodProducts()
            
            return (
                hasRestaurants: !restaurants.isEmpty,
                hasProducts: !products.isEmpty
            )
        } catch {
            print("❌ Error checking database status: \(error)")
            return (hasRestaurants: false, hasProducts: false)
        }
    }
} 
