# Cart Management System

This document explains the cart management system implemented for the Nourish Foods app.

## Overview

The cart system provides internal storage for managing cart items without syncing to Firebase. It uses UserDefaults for persistence and provides a clean API for adding, removing, and managing cart items.

## Components

### 1. CartItem Model (`Models/CartItem.swift`)
- Represents a single item in the cart
- Contains product information and quantity
- Provides computed properties for total price
- Implements `Identifiable`, `Codable`, and `Equatable`

### 2. CartViewModel (`ViewModels/CartViewModel.swift`)
- Manages cart state and operations
- Provides methods for adding, removing, and updating cart items
- Handles persistence using UserDefaults
- Includes computed properties for totals and cart status

### 3. CartView (`Views/Cart/CartView.swift`)
- Main cart interface
- Shows cart items with quantity controls
- Displays order summary with subtotal, delivery fee, and total
- Handles empty cart state

### 4. AddToCartButton (`Views/Cart/AddToCartButton.swift`)
- Reusable component for adding items to cart
- Shows quantity controls when item is already in cart
- Can be used throughout the app

### 5. CartBadge (`Views/Cart/CartBadge.swift`)
- Shows cart item count
- Can be used in navigation bars

## Usage

### Adding CartViewModel to a View

```swift
struct MyView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
        // Your view content
    }
}
```

### Adding Items to Cart

```swift
// Add a single item
cartViewModel.addToCart(product)

// Add multiple items
cartViewModel.addToCart(product, quantity: 3)
```

### Using AddToCartButton

```swift
AddToCartButton(product: product, cartViewModel: cartViewModel)
```

### Using CartBadge

```swift
CartBadge(cartViewModel: cartViewModel)
```

## Key Features

### Cart Management
- Add items to cart
- Remove items from cart
- Update quantities
- Clear entire cart
- Check if item is in cart
- Get item quantity

### Computed Properties
- `totalItems`: Total number of items in cart
- `subtotal`: Sum of all item prices
- `deliveryFee`: Fixed delivery fee (Rs. 150)
- `totalAmount`: Subtotal + delivery fee
- `isCartEmpty`: Boolean indicating if cart is empty
- `isMultiRestaurantOrder`: Boolean indicating if items are from multiple restaurants

### Persistence
- Cart data is automatically saved to UserDefaults
- Cart is restored when app launches
- No network calls required

### Multi-Restaurant Support
- Detects when items are from different restaurants
- Shows warning for multi-restaurant orders
- Groups items by restaurant

## Integration

The cart system is integrated into the main app through `MainAppView.swift`. The `CartViewModel` is provided as an environment object to all views. Navigation is handled through NavigationStack with buttons in the HomeView header.

### Navigation Structure:
- **HomeView**: Main screen with navigation buttons in header
- **Search**: Accessed via magnifying glass button
- **Cart**: Accessed via cart button (with badge showing item count)
- **Profile**: Accessed via person button
- **Delivery**: Accessed via location button

## Example Usage in Product Views

```swift
struct ProductCard: View {
    let product: FoodProduct
    @EnvironmentObject var cartViewModel: CartViewModel
    
    var body: some View {
        VStack {
            // Product details
            AddToCartButton(product: product, cartViewModel: cartViewModel)
        }
    }
}
```

## Cart View Features

- **Empty State**: Shows helpful message when cart is empty
- **Item Management**: Each item shows quantity controls and remove button
- **Order Summary**: Shows subtotal, delivery fee, and total
- **Multi-Restaurant Warning**: Alerts user when items are from different restaurants
- **Checkout Button**: Ready for checkout implementation

## Storage

Cart data is stored in UserDefaults with the key `"savedCartItems"`. The data is automatically encoded/decoded as JSON.

## Future Enhancements

- Checkout functionality
- Order history
- Favorite items
- Coupon/discount support
- Delivery time estimation 