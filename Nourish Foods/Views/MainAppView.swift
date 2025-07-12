import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var dataInitializationVM = DataInitializationViewModel()
    @StateObject private var cartViewModel = CartViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main Content
                HomeView()
                    .environmentObject(cartViewModel)
                    .navigationDestination(for: NavigationDestination.self) { destination in
                        switch destination {
                        case .cart:
                            CartView()
                                .environmentObject(cartViewModel)
                        case .search:
                            SearchView()
                                .environmentObject(cartViewModel)
                        case .delivery:
                            DeliveryTrackingView()
                                .environmentObject(cartViewModel)
                        case .profile:
                            ProfileView()
                                .environmentObject(cartViewModel)
                        }
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
