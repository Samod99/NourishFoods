//
//  AuthViewModel.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-08.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var userProfile: UserProfile?
    @Published var userReviews: [UserReview] = []
    @Published var userOrders: [UserOrder] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let db = Firestore.firestore()
    
    init() {
        // Listen for authentication state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isAuthenticated = user != nil
                self?.currentUser = user
                
                if let user = user {
                    self?.loadUserProfile(userId: user.uid)
                    self?.loadUserReviews(userId: user.uid)
                    self?.loadUserOrders(userId: user.uid)
                } else {
                    self?.userProfile = nil
                    self?.userReviews = []
                    self?.userOrders = []
                }
            }
        }
    }
    
    // MARK: - Authentication Methods
    func login(email: String, password: String) {
        self.isLoading = true
        self.errorMessage = nil
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isAuthenticated = false
                } else {
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    func signup(name: String, email: String, mobile: String, password: String) {
        self.isLoading = true
        self.errorMessage = nil
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.isLoading = false
                    self?.errorMessage = error.localizedDescription
                    self?.isAuthenticated = false
                } else if let user = result?.user {
                    // Create user profile
                    let userProfile = UserProfile(
                        id: user.uid,
                        name: name,
                        email: email,
                        mobile: mobile
                    )
                    
                    // Save user profile to Firestore
                    self?.saveUserProfile(userProfile) { success in
                        self?.isLoading = false
                        if success {
                            self?.isAuthenticated = true
                            self?.userProfile = userProfile
                        } else {
                            self?.errorMessage = "Failed to create user profile"
                            self?.isAuthenticated = false
                        }
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
            self.userProfile = nil
            self.userReviews = []
            self.userOrders = []
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - User Profile Methods
    private func loadUserProfile(userId: String) {
        db.collection("users").document(userId).getDocument { [weak self] document, error in
            DispatchQueue.main.async {
                if let document = document, document.exists {
                    do {
                        let data = document.data() ?? [:]
                        let userProfile = try self?.decodeUserProfile(from: data, userId: userId)
                        self?.userProfile = userProfile
                    } catch {
                        print("Error decoding user profile: \(error)")
                        self?.errorMessage = "Failed to load user profile"
                    }
                } else {
                    print("User profile not found")
                }
            }
        }
    }
    
    private func decodeUserProfile(from data: [String: Any], userId: String) throws -> UserProfile {
        let name = data["name"] as? String ?? ""
        let email = data["email"] as? String ?? ""
        let mobile = data["mobile"] as? String ?? ""
        
        var profile = UserProfile(id: userId, name: name, email: email, mobile: mobile)
        
        // Decode optional fields
        if let profileImageURL = data["profileImageURL"] as? String {
            profile.profileImageURL = profileImageURL
        }
        
        if let dateOfBirthTimestamp = data["dateOfBirth"] as? Timestamp {
            profile.dateOfBirth = dateOfBirthTimestamp.dateValue()
        }
        
        if let addressData = data["address"] as? [String: Any] {
            profile.address = UserProfile.Address(
                street: addressData["street"] as? String ?? "",
                city: addressData["city"] as? String ?? "",
                postalCode: addressData["postalCode"] as? String ?? "",
                country: addressData["country"] as? String ?? "",
                isDefault: addressData["isDefault"] as? Bool ?? false
            )
        }
        
        if let preferencesData = data["preferences"] as? [String: Any] {
            var preferences = UserProfile.UserPreferences()
            
            if let dietaryRestrictions = preferencesData["dietaryRestrictions"] as? [String] {
                preferences.dietaryRestrictions = dietaryRestrictions
            }
            
            if let allergies = preferencesData["allergies"] as? [String] {
                preferences.allergies = allergies
            }
            
            if let favoriteCuisines = preferencesData["favoriteCuisines"] as? [String] {
                preferences.favoriteCuisines = favoriteCuisines
            }
            
            if let notificationData = preferencesData["notificationSettings"] as? [String: Any] {
                preferences.notificationSettings.orderUpdates = notificationData["orderUpdates"] as? Bool ?? true
                preferences.notificationSettings.promotions = notificationData["promotions"] as? Bool ?? true
                preferences.notificationSettings.deliveryAlerts = notificationData["deliveryAlerts"] as? Bool ?? true
                preferences.notificationSettings.healthTips = notificationData["healthTips"] as? Bool ?? true
            }
            
            profile.preferences = preferences
        }
        
        if let createdAtTimestamp = data["createdAt"] as? Timestamp {
            profile.createdAt = createdAtTimestamp.dateValue()
        }
        
        if let updatedAtTimestamp = data["updatedAt"] as? Timestamp {
            profile.updatedAt = updatedAtTimestamp.dateValue()
        }
        
        return profile
    }
    
    func updateUserProfile(_ profile: UserProfile, completion: @escaping (Bool) -> Void) {
        guard let userId = currentUser?.uid else {
            completion(false)
            return
        }
        
        var profileData: [String: Any] = [
            "uid": profile.id,
            "name": profile.name,
            "email": profile.email,
            "mobile": profile.mobile,
            "updatedAt": Timestamp(date: Date())
        ]
        
        if let profileImageURL = profile.profileImageURL {
            profileData["profileImageURL"] = profileImageURL
        }
        
        if let dateOfBirth = profile.dateOfBirth {
            profileData["dateOfBirth"] = Timestamp(date: dateOfBirth)
        }
        
        if let address = profile.address {
            profileData["address"] = [
                "street": address.street,
                "city": address.city,
                "postalCode": address.postalCode,
                "country": address.country,
                "isDefault": address.isDefault
            ]
        }
        
        profileData["preferences"] = [
            "dietaryRestrictions": profile.preferences.dietaryRestrictions,
            "allergies": profile.preferences.allergies,
            "favoriteCuisines": profile.preferences.favoriteCuisines,
            "notificationSettings": [
                "orderUpdates": profile.preferences.notificationSettings.orderUpdates,
                "promotions": profile.preferences.notificationSettings.promotions,
                "deliveryAlerts": profile.preferences.notificationSettings.deliveryAlerts,
                "healthTips": profile.preferences.notificationSettings.healthTips
            ]
        ]
        
        db.collection("users").document(userId).setData(profileData, merge: true) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error updating user profile: \(error)")
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                } else {
                    self?.userProfile = profile
                    completion(true)
                }
            }
        }
    }
    
    private func saveUserProfile(_ profile: UserProfile, completion: @escaping (Bool) -> Void) {
        let profileData: [String: Any] = [
            "uid": profile.id,
            "name": profile.name,
            "email": profile.email,
            "mobile": profile.mobile,
            "createdAt": Timestamp(date: profile.createdAt),
            "updatedAt": Timestamp(date: profile.updatedAt)
        ]
        
        db.collection("users").document(profile.id).setData(profileData) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error saving user profile: \(error)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
    
    // MARK: - User Reviews Methods
    private func loadUserReviews(userId: String) {
        db.collection("reviews")
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error loading user reviews: \(error)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        self?.userReviews = []
                        return
                    }
                    
                    self?.userReviews = documents.compactMap { document in
                        try? document.data(as: UserReview.self)
                    }
                }
            }
    }
    
    func addReview(_ review: UserReview, completion: @escaping (Bool) -> Void) {
        do {
            try db.collection("reviews").document(review.id).setData(from: review) { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error adding review: \(error)")
                        self?.errorMessage = error.localizedDescription
                        completion(false)
                    } else {
                        self?.userReviews.insert(review, at: 0)
                        completion(true)
                    }
                }
            }
        } catch {
            print("Error encoding review: \(error)")
            completion(false)
        }
    }
    
    // MARK: - User Orders Methods
    private func loadUserOrders(userId: String) {
        db.collection("orders")
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
            .limit(to: 20)
            .getDocuments { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error loading user orders: \(error)")
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        self?.userOrders = []
                        return
                    }
                    
                    self?.userOrders = documents.compactMap { document in
                        try? document.data(as: UserOrder.self)
                    }
                }
            }
    }
    
    func saveOrder(_ order: UserOrder, completion: @escaping (Bool) -> Void) {
        do {
            try db.collection("orders").document(order.id).setData(from: order) { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error saving order: \(error)")
                        self?.errorMessage = error.localizedDescription
                        completion(false)
                    } else {
                        self?.userOrders.insert(order, at: 0)
                        completion(true)
                    }
                }
            }
        } catch {
            print("Error encoding order: \(error)")
            completion(false)
        }
    }
    
    func updateOrderStatus(orderId: String, status: UserOrder.OrderStatus, completion: @escaping (Bool) -> Void) {
        var updateData: [String: Any] = [
            "status": status.rawValue,
            "updatedAt": Timestamp(date: Date())
        ]
        
        if status == .delivered {
            updateData["actualDeliveryTime"] = Timestamp(date: Date())
        }
        
        db.collection("orders").document(orderId).updateData(updateData) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error updating order status: \(error)")
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                } else {
                    // Update local order
                    if let index = self?.userOrders.firstIndex(where: { $0.id == orderId }) {
                        var updatedOrder = self?.userOrders[index]
                        // Note: This is a simplified update. In a real app, you'd want to reload the order from Firestore
                        completion(true)
                    } else {
                        completion(true)
                    }
                }
            }
        }
    }
} 
