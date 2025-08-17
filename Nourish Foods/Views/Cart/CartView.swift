//
//  CartView.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-06.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var healthViewModel: HealthTrackingViewModel
    @State private var showingCheckout = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    Spacer()
                    if !cartViewModel.isCartEmpty {
                        Button("Clear All") {
                            cartViewModel.clearCart()
                        }
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
            }
            .padding(.bottom, 10)
            
            if cartViewModel.isCartEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "cart")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("Your cart is empty")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Text("Add some delicious items to get started")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.viewBackground)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 12) {
                        ForEach(cartViewModel.cartItems) { item in
                            CartItemView(item: item, cartViewModel: cartViewModel)
                        }
                    }
                    .padding(.horizontal)
                }
                
                VStack(spacing: 0) {
                    Divider()
                    
                    VStack(spacing: 12) {
                        HStack {
                            Text("Subtotal")
                                .foregroundColor(.black)
                            Spacer()
                            Text(cartViewModel.subtotalString)
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        }
                        
                        HStack {
                            Text("Delivery Fee")
                                .foregroundColor(.black)
                            Spacer()
                            Text(cartViewModel.deliveryFeeString)
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Total")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            Spacer()
                            Text(cartViewModel.totalAmountString)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                    .padding()
                    
                    Button(action: {
                        showingCheckout = true
                    }) {
                        HStack {
                            Text("Proceed to Checkout")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("(\(cartViewModel.totalItems) items)")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding()
                        .background(Color.buttonBackground)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .background(Color.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.viewBackground)
        .navigationTitle("Cart")
        .fullScreenCover(isPresented: $showingCheckout) {
            CheckoutView()
                .environmentObject(cartViewModel)
                .environmentObject(authViewModel)
                .environmentObject(healthViewModel)
        }
    }
}

struct CartItemView: View {
    let item: CartItem
    let cartViewModel: CartViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 12) {
                if let imageURL = item.product.imageURL, !imageURL.isEmpty {
                    Image(imageURL)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                } else {
                    Image("burger01")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            
                            Text(item.product.longName)
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .lineLimit(2)
                            
                            Text(item.product.restaurantName)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            cartViewModel.removeFromCart(item.product)
                        }) {
                            Image(systemName: "trash")
                                .font(.system(size: 16))
                                .foregroundColor(.red)
                        }
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        Text(item.formattedTotalPrice)
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        Spacer()
                        
                        HStack(spacing: 5) {
                            Button(action: {
                                cartViewModel.decrementQuantity(for: item.product)
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.buttonBackground)
                            }
                            
                            Text("\(item.quantity)")
                                .font(.system(size: 16))
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .frame(minWidth: 30)
                            
                            Button(action: {
                                cartViewModel.incrementQuantity(for: item.product)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.buttonBackground)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
                    
                }
                
            }
            .padding(.horizontal)
            .padding(.vertical,5)
            .padding(.top,10)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    CartView()
}
