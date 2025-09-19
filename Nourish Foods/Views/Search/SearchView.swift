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
    @EnvironmentObject var healthViewModel: HealthTrackingViewModel
    
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

#Preview {
    SearchView()
}
