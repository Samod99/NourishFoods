import SwiftUI
import MapKit

struct DeliveryTrackingView: View {
    @StateObject private var viewModel = DemoMapViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var showingCompletionAlert = false
    @State private var showingReview = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismissEnv
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.openURL) var openURL
    @State private var shouldNavigateHome = false

    @State private var showLocationAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                if viewModel.status != "Delivered" {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                } else {
                    // Hide back button after delivery
                    Spacer()
                }
                Spacer()
                Text("Delivery Tracking")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Spacer()
                // Invisible spacer for centering
                if viewModel.status != "Delivered" {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.clear)
                } else {
                    Spacer()
                }
            }
            .padding()
            .background(Color.black)
            
            ZStack {
                // Full screen map
                Map(coordinateRegion: Binding(
                    get: {
                        viewModel.getMapRegion()
                    }, set: { newRegion in
                        region = newRegion
                    }),
                    annotationItems: viewModel.getMapAnnotations()
                ) { item in
                    MapAnnotation(coordinate: item.coordinate) {
                        VStack(spacing: 2) {
                            Image(systemName: item.icon)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(item.color)
                                .clipShape(Circle())
                                .shadow(radius: 3)
                            
                            Text(item.title)
                                .font(.caption2)
                                .foregroundColor(.primary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(.ultraThinMaterial)
                                .cornerRadius(4)
                        }
                    }
                }
                .ignoresSafeArea()
                
                // Top overlay with order info
                VStack {
                    // Order info card
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Order #\(String(format: "%04d", Int.random(in: 1000...9999)))")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                
                                HStack(spacing: 4) {
                                    Text(viewModel.status)
                                        .font(.subheadline)
                                        .foregroundColor(.buttonBackground)
                                        .fontWeight(.medium)
                                    
                                    if viewModel.isPaused {
                                        Text("(PAUSED)")
                                            .font(.caption)
                                            .foregroundColor(.orange)
                                            .fontWeight(.bold)
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                if viewModel.isRunning {
                                    let progressPercentage = viewModel.totalDistance > 0 ? (viewModel.distanceTraveled / viewModel.totalDistance) * 100 : 0
                                    Text("\(Int(progressPercentage))% Complete")
                                        .font(.caption)
                                        .foregroundColor(.buttonBackground)
                                        .fontWeight(.semibold)
                                    
                                    Text("\(viewModel.distanceRemaining)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                } else {
                                    if !viewModel.distanceRemaining.isEmpty {
                                        Text(viewModel.distanceRemaining)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    if !viewModel.estimatedTime.isEmpty {
                                        Text(viewModel.estimatedTime)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        
                        // Progress bar
                        ProgressView(value: viewModel.totalDistance > 0 ? viewModel.distanceTraveled / viewModel.totalDistance : 0, total: 1.0)
                            .progressViewStyle(LinearProgressViewStyle(tint: .buttonBackground))
                            .scaleEffect(y: 2)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    Spacer()
                    
                    // Bottom action buttons
                    if viewModel.status == "Delivered" {
                        VStack(spacing: 12) {
                            Button(action: {
                                showingReview = true
                            }) {
                                HStack {
                                    Image(systemName: "star.fill")
                                    Text("Rate Your Order")
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.buttonBackground)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                dismiss()
                            }) {
                                Text("Done")
                                    .foregroundColor(.buttonBackground)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    } else if !viewModel.isRunning {
                        Button(action: {
                            if viewModel.deliveryLocation == nil {
                                showLocationAlert = true
                            } else {
                                viewModel.startDelivery()
                            }
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Start Delivery")
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.deliveryLocation == nil ? Color.gray : Color.buttonBackground)
                            .cornerRadius(12)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .disabled(viewModel.deliveryLocation == nil)
                    } else {
                        // Delivery in progress - show pause/resume and reset buttons
                        HStack(spacing: 12) {
                            Button(action: {
                                viewModel.togglePause()
                            }) {
                                HStack {
                                    Image(systemName: viewModel.isPaused ? "play.fill" : "pause.fill")
                                    Text(viewModel.isPaused ? "Resume" : "Pause")
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                viewModel.reset()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                    Text("Reset")
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            // Request location permission again in case user returns to this view
            viewModel.status = "Ready"
            viewModel.isRunning = false
            viewModel.currentStep = 0
            viewModel.estimatedTime = ""
            viewModel.distanceRemaining = ""
            viewModel.deliveryLocation = nil
            viewModel.driverLocation = nil
            viewModel.pickupLocation = nil
            viewModel.currentLocation = nil
            viewModel.reset()
            // Proactively request permission
            viewModel.objectWillChange.send()
        }
        .alert("Location Not Available", isPresented: $showLocationAlert) {
            Button("OK") {}
        } message: {
            Text("We couldn't get your location. Please enable location services in Settings and try again.")
        }
        .fullScreenCover(isPresented: $showingReview, onDismiss: {
            // Handle review completion
        }) {
            ReviewView()
        }
        .alert("Delivery Complete!", isPresented: $showingCompletionAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your order has been delivered successfully!")
        }
    }
}

// MARK: - Review View
struct ReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var rating = 5
    @State private var reviewText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Rate Your Experience")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // Star rating
                HStack(spacing: 10) {
                    ForEach(1...5, id: \.self) { star in
                        Button(action: {
                            rating = star
                        }) {
                            Image(systemName: star <= rating ? "star.fill" : "star")
                                .foregroundColor(star <= rating ? .yellow : .gray)
                                .font(.title)
                        }
                    }
                }
                
                // Review text
                TextField("Write your review (optional)", text: $reviewText, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .lineLimit(3...6)
                
                Spacer()
                
                Button(action: {
                    // Save review
                    dismiss()
                }) {
                    Text("Submit Review")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.buttonBackground)
                        .cornerRadius(12)
                }
            }
            .padding()
            .navigationTitle("Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Map Pin Item
struct MapPinItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let color: Color
    let title: String
    let icon: String
}

#Preview {
    DeliveryTrackingView()
} 
