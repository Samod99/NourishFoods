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

class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    private var cancellables = Set<AnyCancellable>()
    private let db = Firestore.firestore()
    
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
                    // Save user info to Firestore
                    let userData: [String: Any] = [
                        "uid": user.uid,
                        "name": name,
                        "email": email,
                        "mobile": mobile
                    ]
                    self?.db.collection("users").document(user.uid).setData(userData) { err in
                        self?.isLoading = false
                        if let err = err {
                            self?.errorMessage = err.localizedDescription
                            self?.isAuthenticated = false
                        } else {
                            self?.isAuthenticated = true
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
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
} 
