//
//  HomeView.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-05.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var cartViewModel: CartViewModel
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var showingNotificationAlert = false
    @State private var notificationTitle = ""
    @State private var notificationBody = ""
    
    var body: some View {
        let userName : String = AuthViewModel().currentUser?.displayName ?? ""
        
        ZStack {
            VStack {
                ScrollView(showsIndicators: false){
                    HStack{
                        VStack (alignment: .leading){
                            
                            HStack {
                                NavigationLink(value: NavigationDestination.profile) {
                                    VStack {
                                        Image(systemName: "person.circle")
                                            .foregroundStyle(Color.black)
                                            .padding(10)
                                            .fontWeight(.medium)
                                            .font(.system(size: 20))
                                    }
                                    .background(Color.white)
                                    .cornerRadius(100)
                                }
                                
                                Text("Hello 👋")
                                    .foregroundStyle(Color.black.opacity(0.5))
                                    .font(.system(size: 15))
                                
                                
                            }
                        }
                        Spacer()
                        
                        NavigationLink(value: NavigationDestination.search) {
                            VStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(Color.black)
                                    .padding(10)
                                    .fontWeight(.medium)
                                
                            }
                            .background(Color.white)
                            .cornerRadius(100)
                        }
                        
                        NavigationLink(value: NavigationDestination.cart) {
                            VStack {
                                ZStack {
                                    Image(systemName: "cart")
                                        .foregroundStyle(Color.black)
                                        .padding(10)
                                        .fontWeight(.medium)
                                    
                                    if cartViewModel.totalItems > 0 {
                                        Text("\(cartViewModel.totalItems)")
                                            .font(.system(size: 8))
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .frame(width: 14, height: 14)
                                            .background(Color.red)
                                            .clipShape(Circle())
                                            .offset(x: 8, y: -8)
                                    }
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(100)
                        }

                        
                    }
                    .padding(.bottom, 10)
                    
                    HStack(spacing: 10) {
                        ForEach(homeViewModel.categories, id: \.title) { category in
                            CategoryCard(
                                imageName: category.imageName,
                                title: category.title,
                                productType: category.productType
                            )
                        }
                    }
                    
                    // Promo Section
                    Button {
                        
                    } label: {
                        Image("promo")
                            .resizable()
                            .scaledToFit()
                            .padding(.vertical,10)
                    }
                    
                    // Test Notification Button (for debugging)
                    Button {
                        NotificationService.shared.sendTestNotification()
                    } label: {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.white)
                            Text("Test Notification")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                        }
                        .padding()
                        .background(Color.buttonBackground)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    // Top Rated Section
                    if !homeViewModel.topRatedProducts.isEmpty {
                        HomeCategoryView(
                            title: "Top Rated",
                            products: homeViewModel.topRatedProducts
                        )
                    }
                    
                    // Best Sales Section
                    if !homeViewModel.bestSalesProducts.isEmpty {
                        HomeCategoryView(
                            title: "Best Sales",
                            products: homeViewModel.bestSalesProducts
                        )
                    }
                    
                    Spacer()
                    
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            
            // Loading overlay
            if homeViewModel.isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                    
                    Text("Loading delicious food...")
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
        .safeAreaPadding(.top, 44)
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.viewBackground)
        .refreshable {
            await homeViewModel.refreshData()
        }
        .alert("Error", isPresented: .constant(homeViewModel.errorMessage != nil)) {
            Button("OK") {
                homeViewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = homeViewModel.errorMessage {
                Text(errorMessage)
            }
        }
        .alert(notificationTitle, isPresented: $showingNotificationAlert) {
            Button("OK") {
                showingNotificationAlert = false
            }
        } message: {
            Text(notificationBody)
        }
        .onAppear {
            setupNotificationAlerts()
        }
    }
    
    private func setupNotificationAlerts() {
        NotificationService.shared.showInAppAlert = { title, body in
            notificationTitle = title
            notificationBody = body
            showingNotificationAlert = true
        }
    }
}
 
struct CategoryCard : View {
    
    let imageName : String
    let title : String
    let productType : FoodProduct.ProductType
    
    var body: some View {
        
        Button {
            print("Selected category: \(title)")
        } label: {
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .padding(.top,15)
                    .padding(.horizontal,20)
                Text(title)
                    .foregroundStyle(Color.black.opacity(0.8))
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                    .padding(.bottom,15)
                
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(20)
        }
        
        
    }
}

struct HomeCategoryView: View {
    
    let title: String
    let products: [FoodProduct]
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(title)
                    .foregroundStyle(Color.black.opacity(0.8))
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                Spacer()
                Button {
                    // TODO: Navigate to see all products
                    print("See all \(title)")
                } label: {
                    Text("See All")
                        .foregroundStyle(Color.buttonBackground)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                }

            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(products, id: \.id) { product in
                    HomeCategoryCardView(product: product)
                }
            }
                
            
        }
        .padding(.bottom)
    }
}


struct HomeCategoryCardView: View {
    let product: FoodProduct
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
            VStack {
                Text(product.shortName)
                    .foregroundStyle(Color.black.opacity(0.8))
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                
                Text(product.formattedPrice)
                    .foregroundStyle(Color.black.opacity(0.5))
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                
                // Use product image if available, otherwise use default
                if let imageURL = product.imageURL, !imageURL.isEmpty {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Image("burger01")
                            .resizable()
                            .scaledToFit()
                    }
                    .padding(.horizontal)
                } else {
                    Image("burger01")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal)
                }
                
                HStack (alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("🔥 \(product.formattedCalories)")
                            .foregroundStyle(Color.black.opacity(0.8))
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .padding(.leading, -5)
                        Text(product.formattedDeliveryTime)
                            .foregroundStyle(Color.black.opacity(0.5))
                            .font(.system(size: 10))
                            .fontWeight(.semibold)
                        
                    }
                    Spacer()
                    
                    Button {
                        NotificationService.shared.sendAddToCartNotification(item: product.shortName)
                        cartViewModel.addToCart(product)

                    } label: {
                        Image(systemName: "plus.app.fill")
                            .foregroundStyle(Color.buttonBackground)
                            .font(.system(size: 36))
                    }

                }
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
      
    }
}



#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(CartViewModel())
}
