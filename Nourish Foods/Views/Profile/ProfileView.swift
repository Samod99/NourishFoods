//
//  ProfileView.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-07.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        ZStack {
            VStack {
                HStack(spacing:15){
                    Circle()
                        .fill(.white)
                        .frame(width:80,height: 80)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Binusha Samod")
                            .foregroundStyle(Color.black.opacity(0.8))
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                        Text("binusha@gmail.com")
                            .font(.system(size: 15))
                            .fontWeight(.regular)
                            .foregroundStyle(Color.black.opacity(0.5))

                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color.viewBackground)
    }
}

#Preview {
    ProfileView()
}
