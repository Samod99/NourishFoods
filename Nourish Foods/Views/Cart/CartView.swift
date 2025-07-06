//
//  CartView.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-06.
//

import SwiftUI

struct CartView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            Text("Cart")
            CartItem()
            CartItem()
            CartItem()
            CartItem()
            CartItem()
            CartItem()
            CartItem()
            CartItem()
            CartItem()
            CartItem()
            CartItem()
            CartItem()
            CartItem()
            CartItem()
            CartItem()
            CartItem()
        }
        .padding()
        .safeAreaPadding(.top, 44)
        .frame(maxWidth: .infinity)
        .background(Color.viewBackground)
        .ignoresSafeArea()

    }
}

struct CartItem: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Image("burger01")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.leading,10)
                VStack(alignment: .leading, spacing: 2){
                    Text("Melting Cheese Pizza")
                        .foregroundStyle(Color.black.opacity(0.8))
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                    Text("Pizza Italiano")
                        .foregroundStyle(Color.black.opacity(0.5))
                        .font(.system(size: 12))
                    
                    
                    HStack {
                        
                        Text("LKR 1890")
                            .foregroundStyle(Color.black.opacity(0.8))
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                            .padding(.top,5)
                        
                        Spacer()
                        
                        VStack {
                            
                            Spacer()
                            
                            HStack(spacing: 5) {
                                
                                Button {
                                    
                                } label: {
                                    Image(systemName: "minus.square.fill")
                                        .font(.system(size: 25))
                                        .foregroundStyle(Color.buttonBackground)
                                }
                                
                                Text("1")
                                    .foregroundStyle(Color.black.opacity(0.8))
                                    .font(.system(size: 22))
                                
                                Button {
                                    
                                } label: {
                                    Image(systemName: "plus.app.fill")
                                        .font(.system(size: 25))
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.buttonBackground)
                                }
                                
                            }
                            .padding(.top,-10)
                            .padding(.bottom,10)
                        }
                        
                    }
                }
                .padding(.top)

                
                Spacer()
                
                
                
                
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
    }
}

#Preview {
    CartView()
}
