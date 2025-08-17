import SwiftUI

struct ProductDetailView: View {
    let product: FoodProduct
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var quantity = 1
    @State private var showingAddToCartSuccess = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Product Image Section
                productImageSection
                
                VStack(alignment: .leading, spacing: 20) {
                    // Product Header
                    productHeaderSection
                    
                    // Product Info Cards
                    productInfoSection
                    
                    // Description
                    descriptionSection
                    
                    // Ingredients
                    if !product.ingredients.isEmpty {
                        ingredientsSection
                    }
                    
                    // Allergens
                    if !product.allergens.isEmpty {
                        allergensSection
                    }
                    
                    // Spacer for bottom padding
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title2)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(value: NavigationDestination.cart) {
                    ZStack {
                        Image(systemName: "cart")
                            .foregroundColor(.buttonBackground)
                            .font(.title2)
                        
                        if cartViewModel.totalItems > 0 {
                            Text("\(cartViewModel.totalItems)")
                                .font(.system(size: 10))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 16, height: 16)
                                .background(Color.red)
                                .clipShape(Circle())
                                .offset(x: 8, y: -8)
                        }
                    }
                }
            }
        }
        .overlay(
            // Add to Cart Button
            VStack {
                Spacer()
                addToCartSection
            }
        )
        .alert("Added to Cart", isPresented: $showingAddToCartSuccess) {
            Button("OK") { }
        } message: {
            Text("\(product.shortName) has been added to your cart!")
        }
    }
    
    // MARK: - Product Image Section
    private var productImageSection: some View {
        ZStack {
            if let imageURL = product.imageURL, !imageURL.isEmpty {
                Image(imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
            } else {
                Image("burger01")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            }
            
            // Product Type Badge
            VStack {
                HStack {
                    Spacer()
                    Text(product.productType.icon)
                        .font(.title)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - Product Header Section
    private var productHeaderSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(product.longName)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(product.restaurantName)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Text(product.formattedPrice)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.buttonBackground)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text(product.formattedCalories)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    // MARK: - Product Info Section
    private var productInfoSection: some View {
        HStack(spacing: 15) {
            InfoCard(
                icon: "clock.fill",
                title: "Delivery",
                value: product.formattedDeliveryTime,
                color: .blue
            )
            
            InfoCard(
                icon: "timer",
                title: "Prep Time",
                value: "\(product.preparationTime) min",
                color: .green
            )
            
            InfoCard(
                icon: "checkmark.circle.fill",
                title: "Status",
                value: product.isAvailable ? "Available" : "Unavailable",
                color: product.isAvailable ? .green : .red
            )
        }
    }
    
    // MARK: - Description Section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text(product.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
    }
    
    // MARK: - Ingredients Section
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredients")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(product.ingredients, id: \.self) { ingredient in
                    HStack {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 6))
                            .foregroundColor(.buttonBackground)
                        Text(ingredient)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
        }
    }
    
    // MARK: - Allergens Section
    private var allergensSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Allergens")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(product.allergens, id: \.self) { allergen in
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 8))
                            .foregroundColor(.red)
                        Text(allergen)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
        }
    }
    
    // MARK: - Add to Cart Section
    private var addToCartSection: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 20) {
                // Quantity Selector
                HStack(spacing: 15) {
                    Button(action: { if quantity > 1 { quantity -= 1 } }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.buttonBackground)
                    }
                    .disabled(quantity <= 1)
                    
                    Text("\(quantity)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .frame(minWidth: 30)
                    
                    Button(action: { quantity += 1 }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.buttonBackground)
                    }
                }
                
                Spacer()
                
                // Add to Cart Button
                Button(action: addToCart) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                        Text("Add to Cart")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 15)
                    .background(product.isAvailable ? Color.buttonBackground : Color.gray)
                    .cornerRadius(25)
                }
                .disabled(!product.isAvailable)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(Color.white)
        }
    }
    
    // MARK: - Helper Methods
    private func addToCart() {
        cartViewModel.addToCart(product, quantity: quantity)
        NotificationService.shared.sendAddToCartNotification(item: product.shortName)
        showingAddToCartSuccess = true
    }
}

// MARK: - Info Card Component
struct InfoCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    NavigationView {
        ProductDetailView(product: SampleData.sampleFoodProducts[0])
            .environmentObject(CartViewModel())
    }
} 
