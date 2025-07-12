import SwiftUI

struct CartBadge: View {
    @ObservedObject var cartViewModel: CartViewModel
    
    var body: some View {
        ZStack {
            Button(action: {
                // Navigate to cart
                print("Cart badge tapped")
            }) {
                Image(systemName: "cart")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
            
            if cartViewModel.totalItems > 0 {
                Text("\(cartViewModel.totalItems)")
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 16, height: 16)
                    .background(Color.red)
                    .clipShape(Circle())
                    .offset(x: 10, y: -10)
            }
        }
    }
}

#Preview {
    HStack {
        CartBadge(cartViewModel: CartViewModel())
        Spacer()
    }
    .padding()
} 