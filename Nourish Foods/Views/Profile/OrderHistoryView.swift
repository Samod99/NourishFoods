import SwiftUI

struct OrderHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    @State private var selectedOrder: UserOrder?
    @State private var showingOrderDetail = false
    
    var body: some View {
        NavigationView {
            VStack {
                if authViewModel.userOrders.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "bag")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Orders Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Text("Your order history will appear here")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(authViewModel.userOrders) { order in
                            OrderHistoryCard(order: order) {
                                selectedOrder = order
                                showingOrderDetail = true
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color.viewBackground)
            .navigationTitle("Order History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingOrderDetail) {
                if let order = selectedOrder {
                    OrderDetailView(order: order)
                }
            }
        }
    }
}

struct OrderHistoryCard: View {
    let order: UserOrder
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Order #\(String(order.id.prefix(8)))")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text(order.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Rs. \(String(format: "%.2f", order.total))")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.buttonBackground)
                        
                        Text(order.status.rawValue)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(order.status.color))
                            )
                    }
                }
                
                // Order items preview
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(order.items.prefix(2)) { item in
                        HStack {
                            Text("• \(item.productName)")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            Spacer()
                            Text("x\(item.quantity)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    if order.items.count > 2 {
                        Text("+ \(order.items.count - 2) more items")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                if let estimatedTime = order.estimatedDeliveryTime {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                            .font(.caption)
                        Text("Estimated: \(estimatedTime, style: .time)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OrderDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let order: UserOrder
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Order Header
                    VStack(spacing: 15) {
                        Text("Order #\(String(order.id.prefix(8)))")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(order.date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(order.status.rawValue)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(order.status.color))
                            )
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    // Order Items
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Order Items")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        ForEach(order.items) { item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.productName)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text(item.restaurantName)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("Rs. \(String(format: "%.2f", item.totalPrice))")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text("x\(item.quantity)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 8)
                            
                            if item.id != order.items.last?.id {
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    // Order Summary
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Order Summary")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Subtotal")
                                Spacer()
                                Text("Rs. \(String(format: "%.2f", order.total - order.deliveryFee))")
                            }
                            
                            HStack {
                                Text("Delivery Fee")
                                Spacer()
                                Text("Rs. \(String(format: "%.2f", order.deliveryFee))")
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Total")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("Rs. \(String(format: "%.2f", order.total))")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.buttonBackground)
                            }
                        }
                        .font(.subheadline)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    // Delivery Information
                    if let deliveryAddress = order.deliveryAddress {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Delivery Address")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(deliveryAddress)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    
                    // Payment Information
                    if let paymentMethod = order.paymentMethod {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Payment Method")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(paymentMethod)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    
                    // Delivery Times
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Delivery Information")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 8) {
                            if let estimatedTime = order.estimatedDeliveryTime {
                                HStack {
                                    Text("Estimated Delivery")
                                    Spacer()
                                    Text(estimatedTime, style: .time)
                                }
                            }
                            
                            if let actualTime = order.actualDeliveryTime {
                                HStack {
                                    Text("Actual Delivery")
                                    Spacer()
                                    Text(actualTime, style: .time)
                                }
                            }
                        }
                        .font(.subheadline)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                }
                .padding()
            }
            .background(Color.viewBackground)
            .navigationTitle("Order Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    OrderHistoryView(authViewModel: AuthViewModel())
} 