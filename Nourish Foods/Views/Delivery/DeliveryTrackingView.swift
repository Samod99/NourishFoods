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
                if let current = viewModel.currentLocation, let delivery = viewModel.deliveryLocation {
                    Map(coordinateRegion: Binding(
                        get: {
                            // Center map between current location and delivery location for better tracking view
                            let centerLat = (current.latitude + delivery.latitude) / 2
                            let centerLon = (current.longitude + delivery.longitude) / 2
                            return MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        }, set: { newRegion in
                            region = newRegion
                        }),
                        annotationItems: [
                            MapPinItem(coordinate: current, color: .red, title: "Your Location", icon: "house.fill"),
                            MapPinItem(coordinate: delivery, color: .green, title: "Delivery", icon: "car.fill")
                        ]) { item in
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
                } else {
                    ProgressView("Loading delivery map...")
                        .ignoresSafeArea()
                }
                
                // Top overlay with order info
                VStack {
                    // Order info card
                    VStack(spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Order #12345")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Text("Estimated delivery: 20 min")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            
                            Button(action: {
                                // Call delivery person
                            }) {
                                Image(systemName: "phone.fill")
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.green)
                                    .clipShape(Circle())
                            }
                        }
                        
                        // Delivery progress
                        VStack(spacing: 8) {
                            HStack {
                                Text("Order Status")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                Text(viewModel.status)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.buttonBackground)
                            }
                            
                            // Progress bar - updated to use 20 steps total
                            ProgressView(value: Double(viewModel.currentStep), total: 20)
                                .progressViewStyle(LinearProgressViewStyle(tint: .buttonBackground))
                                .scaleEffect(y: 2)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding()
                    
                    Spacer()
                    
                    // Bottom overlay with delivery info
                    VStack(spacing: 16) {
                        // Delivery person info
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.buttonBackground)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                        .font(.title2)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("John Doe")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Text("Your delivery partner")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("ETA")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(max(0, 20 - viewModel.currentStep)) min")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.buttonBackground)
                            }
                        }
                        
                        // Delivery status info
                        HStack {
                            Text("Status: \(viewModel.status)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("ETA: \(max(0, 20 - viewModel.currentStep)) min")
                                .font(.subheadline)
                                .foregroundColor(.buttonBackground)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                    )
                    .padding(.horizontal, 20)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .onAppear {
            // Start tracking immediately when view appears
            viewModel.startDemo()
        }
        .onChange(of: viewModel.status) { status in
            if status == "Delivered" {
                showingReview = true
            }
        }
        .fullScreenCover(isPresented: $showingReview, onDismiss: {
            // After review, go to HomeView and clear navigation stack
            shouldNavigateHome = true
        }) {
            ReviewView(onSubmit: { rating, comment in
                // Save review logic here if needed
                showingReview = false
            }, onCancel: {
                showingReview = false
            })
        }
        .onChange(of: shouldNavigateHome) { goHome in
            if goHome {
                // Reset navigation to HomeView
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = UIHostingController(rootView: MainAppView().environmentObject(AuthViewModel()))
                    window.makeKeyAndVisible()
                }
            }
        }
            .alert("Delivery Complete!", isPresented: $showingCompletionAlert) {
                Button("Great!") {
                    dismiss()
                }
            } message: {
                Text("Your order has been delivered successfully. Enjoy your meal! 🍕")
            }
    }
}

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
