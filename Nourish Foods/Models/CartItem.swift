import Foundation

struct CartItem: Identifiable, Codable, Equatable {
    let id = UUID()
    let product: FoodProduct
    var quantity: Int
    
    init(product: FoodProduct, quantity: Int = 1) {
        self.product = product
        self.quantity = quantity
    }
    
    // MARK: - Computed Properties
    var totalPrice: Double {
        return product.price * Double(quantity)
    }
    
    var formattedTotalPrice: String {
        return String(format: "Rs. %.2f", totalPrice)
    }
    
    // MARK: - Equatable
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.product.id == rhs.product.id
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id
        case product
        case quantity
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        product = try container.decode(FoodProduct.self, forKey: .product)
        quantity = try container.decode(Int.self, forKey: .quantity)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(product, forKey: .product)
        try container.encode(quantity, forKey: .quantity)
    }
} 