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
    @EnvironmentObject var healthViewModel: HealthTrackingViewModel
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var showingNotificationAlert = false
    @State private var notificationTitle = ""
    @State private var notificationBody = ""
    @State private var isSearching = false
    
    var body: some View {
        
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
                        
                        // Search Button - now toggles search mode
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isSearching.toggle()
                                if !isSearching {
                                    searchViewModel.clearFilters()
                                }
                            }
                        }) {
                            VStack {
                                Image(systemName: isSearching ? "xmark" : "magnifyingglass")
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
                        
                        NavigationLink(value: NavigationDestination.delivery) {
                            VStack {
                                Image(systemName: "location.fill")
                                    .foregroundStyle(Color.black)
                                    .padding(10)
                                    .fontWeight(.medium)
                            }
                            .background(Color.white)
                            .cornerRadius(100)
                        }

                        
                    }
                    .padding(.bottom, 10)
                    
                    // Search Bar - only show when searching
                    if isSearching {
                        VStack(spacing: 15) {
                            // Search Bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                
                                TextField("Search for food, restaurants...", text: $searchViewModel.searchText)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .onChange(of: searchViewModel.searchText) { _ in
                                        searchViewModel.searchProducts()
                                    }
                                
                                if !searchViewModel.searchText.isEmpty {
                                    Button("Clear") {
                                        searchViewModel.clearFilters()
                                    }
                                    .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                            // Category Filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    // All Categories Button
                                    Button(action: {
                                        searchViewModel.filterByCategory(nil)
                                    }) {
                                        Text("All")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(searchViewModel.selectedCategory == nil ? .white : .buttonBackground)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(searchViewModel.selectedCategory == nil ? Color.buttonBackground : Color.white)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.buttonBackground, lineWidth: 1)
                                            )
                                    }
                                    
                                    // Category Buttons
                                    ForEach(searchViewModel.allProductTypes, id: \.self) { category in
                                        Button(action: {
                                            searchViewModel.filterByCategory(category)
                                        }) {
                                            HStack(spacing: 4) {
                                                Text(category.icon)
                                                Text(category.displayName)
                                                    .font(.system(size: 14, weight: .medium))
                                            }
                                            .foregroundColor(searchViewModel.selectedCategory == category ? .white : .buttonBackground)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 8)
                                            .background(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(searchViewModel.selectedCategory == category ? Color.buttonBackground : Color.white)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color.buttonBackground, lineWidth: 1)
                                            )
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    
                    // Content based on search state
                    if isSearching {
                        // Search Results
                        if searchViewModel.isLoading {
                            VStack {
                                ProgressView()
                                    .scaleEffect(1.5)
                                    .padding()
                                
                                Text("Searching for delicious food...")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if searchViewModel.searchResults.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                
                                Text("No products found")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray)
                                
                                Text("Try adjusting your search or filters")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                ForEach(searchViewModel.searchResults, id: \.id) { product in
                                    SearchProductCard(product: product)
                                }
                            }
                            .padding()
                        }
                    } else {
                        // Regular Home Content
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
                        
                        // Healthy Foods Section
                        if !homeViewModel.healthyFoods.isEmpty {
                            HomeCategoryView(
                                title: "Healthy Foods",
                                products: homeViewModel.healthyFoods
                            )
                        }
                        
                        // Best Sales Section
                        if !homeViewModel.bestSalesProducts.isEmpty {
                            HomeCategoryView(
                                title: "Best Sales",
                                products: homeViewModel.bestSalesProducts
                            )
                        }
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
            if isSearching {
                await searchViewModel.refreshData()
            } else {
                await homeViewModel.refreshData()
            }
        }
        .alert("Error", isPresented: .constant(homeViewModel.errorMessage != nil || searchViewModel.errorMessage != nil)) {
            Button("OK") {
                homeViewModel.errorMessage = nil
                searchViewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = homeViewModel.errorMessage {
                Text(errorMessage)
            } else if let errorMessage = searchViewModel.errorMessage {
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
    @EnvironmentObject var healthViewModel: HealthTrackingViewModel

    var body: some View {
        NavigationLink(destination: ProductDetailView(product: product)
            .environmentObject(cartViewModel)) {
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
                    Image(imageURL)
                        .resizable()
                        .scaledToFit()
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
                        
                        // Add to health tracking
                        healthViewModel.addFoodToTracking(product, quantity: 1)
                    } label: {
                        Image(systemName: "plus.app.fill")
                            .foregroundStyle(Color.buttonBackground)
                            .font(.system(size: 36))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}



struct SearchProductCard: View {
    let product: FoodProduct
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
        NavigationLink(destination: ProductDetailView(product: product)
            .environmentObject(cartViewModel)) {
            VStack(alignment: .leading, spacing: 8) {
                // Product Image
                if let imageURL = product.imageURL, !imageURL.isEmpty {
                    Image(imageURL)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 120)
                        .clipped()
                } else {
                    Image("burger01")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    // Product Name
                    Text(product.shortName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    // Restaurant Name
                    Text(product.restaurantName)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    // Price and Calories
                    HStack {
                        Text(product.formattedPrice)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.buttonBackground)
                        
                        Spacer()
                        
                        Text("🔥 \(product.formattedCalories)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    // Delivery Time
                    HStack {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        Text(product.formattedDeliveryTime)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button(action: {
                            cartViewModel.addToCart(product)
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.buttonBackground)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
        .environmentObject(CartViewModel())
}
