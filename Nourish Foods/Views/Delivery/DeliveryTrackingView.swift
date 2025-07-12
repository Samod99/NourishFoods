import SwiftUI
import MapKit

struct DeliveryTrackingView: View {
    @StateObject private var viewModel = DemoMapViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var showingCompletionAlert = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
        var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.white)
                
                Spacer()
                
                Text("Delivery Tracking")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Invisible spacer for centering
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.clear)
            }
            .padding()
            .background(Color.black)
            
            ZStack {
                // Full screen map
                if let current = viewModel.currentLocation, let pickup = viewModel.pickupLocation {
                    Map(coordinateRegion: Binding(
                        get: {
                            MKCoordinateRegion(
                                center: current,
                                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            )
                        }, set: { newRegion in
                            region = newRegion
                        }),
                        annotationItems: [
                            MapPinItem(coordinate: current, color: .red, title: "Your Location", icon: "house.fill"),
                            MapPinItem(coordinate: pickup, color: .green, title: "Restaurant", icon: "building.2.fill")
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
                                Text("Estimated delivery: 25-30 min")
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
                            
                            // Progress bar
                            ProgressView(value: Double(viewModel.currentStep), total: 60)
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
                                Text("\(max(0, 60 - viewModel.currentStep)) min")
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
                                                            Text("ETA: \(max(0, 60 - viewModel.currentStep)) min")
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
                // Auto-start tracking when view appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    viewModel.startDemo()
                }
            }
            .onChange(of: viewModel.status) { status in
                if status == "Delivered" {
                    showingCompletionAlert = true
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