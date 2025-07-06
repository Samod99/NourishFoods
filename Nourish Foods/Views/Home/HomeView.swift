//
//  HomeView.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-05.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            VStack {
                ScrollView(showsIndicators: false){
                    HStack{
                        VStack (alignment: .leading){
                            Text("Hello 👋")
                                .foregroundStyle(Color.black.opacity(0.5))
                                .font(.system(size: 15))
                            Text("Binusha Samod")
                                .foregroundStyle(Color.black.opacity(0.8))
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                            
                        }
                        Spacer()
                        
                        Button {
                            print("Button Tappex")
                        } label: {
                            VStack {
                                Image(systemName: "bell")
                                    .foregroundStyle(Color.black)
                                    .padding(10)
                                    .fontWeight(.medium)
                                
                            }
                            .background(Color.white)
                            .cornerRadius(100)
                            
                        }
                        
                        Button {
                            print("Button Tappex")
                        } label: {
                            VStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(Color.black)
                                    .padding(10)
                                    .fontWeight(.medium)
                                
                            }
                            .background(Color.white)
                            .cornerRadius(100)
                            
                        }
                        
                    }
                    
                    HStack(spacing: 10) {
                        CategoryCard(imageName: "meat", title: "Meat")
                        CategoryCard(imageName: "burger", title: "Fast Food")
                        CategoryCard(imageName: "fruit", title: "Fruits")
                        CategoryCard(imageName: "juice", title: "Juice")
                        
                    }
                    
                    Button {
                        
                    } label: {
                        Image("promo")
                            .resizable()
                            .scaledToFit()
                            .padding(.vertical,10)
                    }
                    
                    HomeCategoryView(title: "Top Rated")
                    HomeCategoryView(title: "Best Sales")
                    
                    
                    Spacer()
                    
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
        }
        .safeAreaPadding(.top, 44)
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.viewBackground)
    }
}
 
struct CategoryCard : View {
    
    let imageName : String
    let title : String
    
    var body: some View {
        
        Button {
            
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
    
    var body: some View {
        VStack {
            HStack(alignment: .bottom) {
                Text(title)
                    .foregroundStyle(Color.black.opacity(0.8))
                    .font(.system(size: 25))
                    .fontWeight(.bold)
                Spacer()
                Button {
                    
                } label: {
                    Text("See All")
                        .foregroundStyle(Color.buttonBackground)
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                }

            }
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    HomeCategoryCardView()
                    HomeCategoryCardView()
                    HomeCategoryCardView()
                    HomeCategoryCardView()
                    HomeCategoryCardView()
                    HomeCategoryCardView()
                }
                
            
        }
        .padding(.bottom)
    }
}


struct HomeCategoryCardView: View {
    var body: some View {
            VStack {
                Text("Melting Chese Pizza")
                    .foregroundStyle(Color.black.opacity(0.8))
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                Text("LKR 1299")
                    .foregroundStyle(Color.black.opacity(0.5))
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                Image("burger01")
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
                
                HStack (alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("🔥 44 Caleries")
                            .foregroundStyle(Color.black.opacity(0.8))
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                            .padding(.leading, -5)
                        Text("30 min")
                            .foregroundStyle(Color.black.opacity(0.5))
                            .font(.system(size: 10))
                            .fontWeight(.semibold)
                        
                    }
                    Spacer()
                    
                    Button {
                        
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
}
