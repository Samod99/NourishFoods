import SwiftUI

struct UserReviewsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    @State private var showingAddReview = false
    
    var body: some View {
        NavigationView {
            VStack {
                if authViewModel.userReviews.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "star.bubble")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Reviews Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Text("Share your dining experiences with others")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        
                        Button("Write Your First Review") {
                            showingAddReview = true
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.buttonBackground)
                        )
                        .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(authViewModel.userReviews) { review in
                            ReviewCard(review: review)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .background(Color.viewBackground)
            .navigationTitle("My Reviews")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Review") {
                        showingAddReview = true
                    }
                    .disabled(authViewModel.userReviews.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddReview) {
                AddReviewView(authViewModel: authViewModel)
            }
        }
    }
}

struct ReviewCard: View {
    let review: UserReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(review.restaurantName)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(review.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= review.rating ? "star.fill" : "star")
                            .foregroundColor(star <= review.rating ? .yellow : .gray)
                            .font(.caption)
                    }
                }
            }
            
            if !review.comment.isEmpty {
                Text(review.comment)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

struct AddReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    @State private var selectedRestaurant = ""
    @State private var rating = 5
    @State private var comment = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private let restaurants = SampleData.sampleRestaurants.map { $0.name }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Restaurant Selection
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Restaurant")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Menu {
                            ForEach(restaurants, id: \.self) { restaurant in
                                Button(restaurant) {
                                    selectedRestaurant = restaurant
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedRestaurant.isEmpty ? "Select Restaurant" : selectedRestaurant)
                                    .foregroundColor(selectedRestaurant.isEmpty ? .gray : .primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    
                    // Rating Selection
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Rating")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack(spacing: 15) {
                            ForEach(1...5, id: \.self) { star in
                                Button(action: {
                                    rating = star
                                }) {
                                    Image(systemName: star <= rating ? "star.fill" : "star")
                                        .font(.title2)
                                        .foregroundColor(star <= rating ? .yellow : .gray)
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    // Comment
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Review")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        TextField("Share your experience...", text: $comment, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(5...10)
                    }
                    
                    // Submit Button
                    Button(action: submitReview) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.white)
                            }
                            Text(isLoading ? "Submitting..." : "Submit Review")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.buttonBackground)
                        )
                    }
                    .disabled(isLoading || !isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.6)
                    .padding(.top)
                }
                .padding()
            }
            .background(Color.viewBackground)
            .navigationTitle("Add Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Review Submission", isPresented: $showingAlert) {
                Button("OK") {
                    if alertMessage.contains("successfully") {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private var isFormValid: Bool {
        !selectedRestaurant.isEmpty && !comment.isEmpty
    }
    
    private func submitReview() {
        guard let userId = authViewModel.currentUser?.uid else { return }
        
        isLoading = true
        
        let review = UserReview(
            userId: userId,
            restaurantId: "", 
            restaurantName: selectedRestaurant,
            rating: rating,
            comment: comment
        )
        
        authViewModel.addReview(review) { success in
            isLoading = false
            if success {
                alertMessage = "Review submitted successfully!"
            } else {
                alertMessage = "Failed to submit review. Please try again."
            }
            showingAlert = true
        }
    }
}

#Preview {
    UserReviewsView(authViewModel: AuthViewModel())
} 