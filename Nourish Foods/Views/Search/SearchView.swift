//
//  SearchView.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-06.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var searchViewModel = SearchViewModel()
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
            VStack(spacing: 0) {
                // Search Header
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
                .padding(.top)
                .background(Color.viewBackground)
                
                // Results
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
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            ForEach(searchViewModel.searchResults, id: \.id) { product in
                                SearchProductCard(product: product)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .refreshable {
                await searchViewModel.refreshData()
            }
            .alert("Error", isPresented: .constant(searchViewModel.errorMessage != nil)) {
                Button("OK") {
                    searchViewModel.errorMessage = nil
                }
            } message: {
                if let errorMessage = searchViewModel.errorMessage {
                    Text(errorMessage)
                }
            }
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
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Image("burger01")
                            .resizable()
                            .scaledToFit()
                    }
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
    SearchView()
}
