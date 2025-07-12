import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cartViewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeliveryTracking = false
    @State private var selectedPaymentMethod = PaymentMethod.creditCard
    @State private var cardNumber = ""
    @State private var cardHolderName = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var deliveryAddress = ""
    @State private var phoneNumber = ""
    @State private var isProcessingPayment = false
    @State private var showingPaymentSuccess = false
    @State private var showingPaymentError = false
    @State private var errorMessage = ""
    
    enum PaymentMethod: String, CaseIterable {
        case creditCard = "Credit Card"
        
        var icon: String {
            return "creditcard.fill"
        }
    }
    
        var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.buttonBackground)
                
                Spacer()
                
                Text("Checkout")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Invisible spacer for centering
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.clear)
            }
            .padding()
            .background(Color.viewBackground)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Order Summary
                    orderSummarySection
                    
                    // Delivery Information
                    deliveryInfoSection
                    
                    // Payment Method
                    paymentMethodSection
                    
                    // Payment Details
                    paymentDetailsSection
                    
                    // Total and Checkout Button
                    checkoutSection
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.viewBackground)
        .fullScreenCover(isPresented: $showingDeliveryTracking) {
            DeliveryTrackingView()
        }
        .alert("Payment Successful!", isPresented: $showingPaymentSuccess) {
            Button("Continue to Delivery") {
                showingDeliveryTracking = true
            }
        } message: {
            Text("Your order has been placed successfully. You can track your delivery in the next screen.")
        }
        .alert("Payment Failed", isPresented: $showingPaymentError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Order Summary Section
    private var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Summary")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                ForEach(cartViewModel.cartItems, id: \.id) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.product.shortName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text(item.product.restaurantName)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("x\(item.quantity)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(item.formattedTotalPrice)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Divider()
            
            // Order totals
            VStack(spacing: 8) {
                                        HStack {
                            Text("Subtotal")
                            Spacer()
                            Text(cartViewModel.subtotalString)
                        }
                        
                        HStack {
                            Text("Delivery Fee")
                            Spacer()
                            Text(cartViewModel.deliveryFeeString)
                        }
                        
                        HStack {
                            Text("Total")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(cartViewModel.totalAmountString)
                                .fontWeight(.semibold)
                                .foregroundColor(.buttonBackground)
                        }
            }
            .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    // MARK: - Delivery Information Section
    private var deliveryInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Delivery Information")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                TextField("Delivery Address", text: $deliveryAddress, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3...6)
                
                TextField("Phone Number", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    // MARK: - Payment Method Section
    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Method")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                ForEach(PaymentMethod.allCases, id: \.self) { method in
                    Button(action: {
                        selectedPaymentMethod = method
                    }) {
                        HStack {
                            Image(systemName: method.icon)
                                .foregroundColor(.buttonBackground)
                                .frame(width: 20)
                            
                            Text(method.rawValue)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if selectedPaymentMethod == method {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.buttonBackground)
                            }
                        }
                        .padding()
                        .background(selectedPaymentMethod == method ? Color.buttonBackground.opacity(0.1) : Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    // MARK: - Payment Details Section
    private var paymentDetailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Card Details")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                TextField("Card Number", text: $cardNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                TextField("Cardholder Name", text: $cardHolderName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack(spacing: 12) {
                    TextField("MM/YY", text: $expiryDate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    TextField("CVV", text: $cvv)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    // MARK: - Checkout Section
    private var checkoutSection: some View {
        VStack(spacing: 12) {
            Button(action: processPayment) {
                HStack {
                    if isProcessingPayment {
                        ProgressView()
                            .scaleEffect(0.8)
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "creditcard.fill")
                    }
                    
                    Text(isProcessingPayment ? "Processing..." : "Place Order")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(canProceed ? Color.buttonBackground : Color.gray)
                .cornerRadius(12)
            }
            .disabled(!canProceed || isProcessingPayment)
            
            Text("By placing this order, you agree to our terms and conditions.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    // MARK: - Computed Properties
    private var canProceed: Bool {
        return !deliveryAddress.isEmpty && !phoneNumber.isEmpty && 
               !cardNumber.isEmpty && !cardHolderName.isEmpty && 
               !expiryDate.isEmpty && !cvv.isEmpty
    }
    
    // MARK: - Helper Methods
    private func processPayment() {
        isProcessingPayment = true
        
        // Simulate payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessingPayment = false
            
            // Simulate 90% success rate
            if Double.random(in: 0...1) < 0.9 {
                showingPaymentSuccess = true
                // Clear cart after successful payment
                cartViewModel.clearCart()
            } else {
                errorMessage = "Payment failed. Please check your card details and try again."
                showingPaymentError = true
            }
        }
    }
}

#Preview {
    CheckoutView()
        .environmentObject(CartViewModel())
} 
