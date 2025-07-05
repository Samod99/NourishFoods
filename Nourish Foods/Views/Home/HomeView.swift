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
                
                HStack {
                    CategoryCard(imageName: "meat", title: "Meat")
                    CategoryCard(imageName: "burger", title: "Fast Food")
                    CategoryCard(imageName: "fruit", title: "Fruits")
                    CategoryCard(imageName: "juice", title: "Juice")

                }
                
                Spacer()
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.viewBackground)
    }
}
 
struct CategoryCard : View {
    
    let imageName : String
    let title : String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .padding(.top,15)
                .padding(.horizontal,15)
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



#Preview {
    HomeView()
}
