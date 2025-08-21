import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var biometricManager: BiometricManager
    @StateObject private var dataInitializationVM = DataInitializationViewModel()
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var healthViewModel = HealthTrackingViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                            // Home Tab
            NavigationStack {
                HomeView()
                    .environmentObject(cartViewModel)
                    .environmentObject(healthViewModel)
                    .environmentObject(authViewModel)
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        switch destination {
                        case .cart:
                            CartView()
                                .environmentObject(cartViewModel)
                                .environmentObject(authViewModel)
                                .environmentObject(healthViewModel)
                        case .search:
                            SearchView()
                                .environmentObject(cartViewModel)
                                .environmentObject(healthViewModel)
                                .environmentObject(authViewModel)
                        case .delivery:
                            DeliveryTrackingView()
                                .environmentObject(cartViewModel)
                                .environmentObject(authViewModel)
                                .environmentObject(healthViewModel)
                        case .profile:
                            ProfileView()
                                .environmentObject(cartViewModel)
                                .environmentObject(authViewModel)
                                .environmentObject(healthViewModel)
                        }
                    }
            }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
                
                            // Health Tab
            HealthDashboardView(healthViewModel: healthViewModel)
                .environmentObject(cartViewModel)
                .environmentObject(authViewModel)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Health")
                }
                .tag(1)
            
            // Cart Tab
            CartView()
                .environmentObject(cartViewModel)
                .environmentObject(authViewModel)
                .environmentObject(healthViewModel)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Cart")
                }
                .tag(2)
            
            // Profile Tab
            ProfileView()
                .environmentObject(cartViewModel)
                .environmentObject(authViewModel)
                .environmentObject(healthViewModel)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
                    }
        .accentColor(.buttonBackground)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.black, for: .tabBar)
        .onAppear {
            // Initial connection of ViewModels with AuthViewModel
            cartViewModel.authViewModel = authViewModel
            
            // Check biometric authentication if user is logged in
            if biometricManager.shouldPromptForBiometrics() {
                biometricManager.authenticateWithBiometrics()
            }
        }
        .onReceive(authViewModel.$isAuthenticated) { _ in
            // Connect ViewModels with AuthViewModel whenever authentication state changes
            cartViewModel.authViewModel = authViewModel
            // Reload cart for the authenticated user
            cartViewModel.reloadCartForUser()
        }
        
        // Show initialization overlay if needed
        if dataInitializationVM.isInitializing {
            VStack {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                
                Text(dataInitializationVM.initializationMessage)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3))
            .cornerRadius(12)
            .padding()
        }
        
        // Show login screen if biometric authentication fails
        if biometricManager.showLoginScreen {
            AuthenticationView()
                .environmentObject(authViewModel)
                .environmentObject(biometricManager)
                .transition(.opacity)
        }
        }
        .task {
            // Initialize sample data if needed when app starts
            await dataInitializationVM.initializeSampleDataIfNeeded()
        }
    }
}

// Navigation destinations enum
enum NavigationDestination: Hashable {
    case cart
    case search
    case delivery
    case profile
}

#Preview {
    MainAppView()
        .environmentObject(AuthViewModel())
} 
