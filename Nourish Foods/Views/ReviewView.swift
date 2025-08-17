import SwiftUI

struct ReviewView1: View {
    @State private var rating: Int = 0
    @State private var comment: String = ""
    var onSubmit: ((Int, String) -> Void)?
    var onCancel: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Rate Your Delivery")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            // Star Rating
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            rating = star
                        }
                }
            }
            
            // Text Feedback
            TextField("Write a review...", text: $comment, axis: .vertical)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .frame(minHeight: 80, maxHeight: 120)
            
            HStack(spacing: 16) {
                Button(action: {
                    onCancel?()
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    onSubmit?(rating, comment)
                }) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(rating > 0 ? Color.buttonBackground : Color.gray.opacity(0.2))
                        .foregroundColor(rating > 0 ? .white : .gray)
                        .cornerRadius(10)
                }
                .disabled(rating == 0)
            }
            .padding(.bottom)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
    }
}

#Preview {
    ReviewView()
} 
