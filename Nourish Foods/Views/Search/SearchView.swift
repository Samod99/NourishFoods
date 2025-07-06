//
//  SearchView.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-06.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                HomeCategoryCardView()
                HomeCategoryCardView()
                HomeCategoryCardView()
                HomeCategoryCardView()
                HomeCategoryCardView()
                HomeCategoryCardView()
                HomeCategoryCardView()
                HomeCategoryCardView()
                HomeCategoryCardView()
                HomeCategoryCardView()
                HomeCategoryCardView()
                HomeCategoryCardView()
            }
        }
    }
}

#Preview {
    SearchView()
}
