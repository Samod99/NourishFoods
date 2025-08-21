import Foundation
import LocalAuthentication
import SwiftUI

class BiometricManager: ObservableObject {
    @Published var isBiometricAvailable = false
    @Published var biometricType: LABiometryType = .none
    @Published var isAuthenticated = false
    @Published var showLoginScreen = false
    
    private let context = LAContext()
    
    init() {
        checkBiometricAvailability()
    }
    
    // Check if biometric authentication is available
    func checkBiometricAvailability() {
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            isBiometricAvailable = true
            biometricType = context.biometryType
        } else {
            isBiometricAvailable = false
            biometricType = .none
            print("Biometric authentication not available: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
    
    // Authenticate user with biometrics
    func authenticateWithBiometrics() {
        guard isBiometricAvailable else {
            showLoginScreen = true
            return
        }
        
        let reason = "Log in to your account"
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.isAuthenticated = true
                    self?.showLoginScreen = false
                } else {
                    self?.isAuthenticated = false
                    self?.showLoginScreen = true
                    
                    if let error = error {
                        print("Biometric authentication failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // Get biometric type description
    func getBiometricTypeDescription() -> String {
        switch biometricType {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        case .none:
            return "None"
        @unknown default:
            return "Unknown"
        }
    }
    
    // Reset authentication state
    func resetAuthentication() {
        isAuthenticated = false
        showLoginScreen = false
    }
    
    // Check if user should be prompted for biometric authentication
    func shouldPromptForBiometrics() -> Bool {
        return isBiometricAvailable && !isAuthenticated
    }
} 