import Foundation

struct Order: Identifiable, Codable {
    let id: UUID
    let items: [CartItem]
    let total: Double
    let date: Date
    let status: String
    
    init(items: [CartItem], total: Double, status: String) {
        self.id = UUID()
        self.items = items
        self.total = total
        self.date = Date()
        self.status = status
    }
} 
