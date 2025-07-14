////
////  DemoMapView.swift
////  Nourish Foods
////
////  Created by Guest User on 2025-07-09.
////
//
import SwiftUI
import MapKit

struct DemoMapView: View {
    @StateObject private var viewModel = DemoMapViewModel()
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    @State private var isSelectingAddress = true
    
    var body: some View {
        ZStack {
            // Full screen map
            if let current = viewModel.currentLocation {
                Map(coordinateRegion: $region)
                    .ignoresSafeArea()
                // Center pin overlay
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
                    .offset(y: -20)
            } else {
                ProgressView("Loading map...")
                    .ignoresSafeArea()
            }
            
            VStack {
                Spacer()
                if isSelectingAddress {
                    Button(action: {
                        // Set delivery location to map center
                        viewModel.setDeliveryLocation(region.center)
                        isSelectingAddress = false
                    }) {
                        Text("Set Delivery Address")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.buttonBackground)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 40)
                } else {
                    // Show delivery status and actions (existing UI)
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Delivery Status")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(viewModel.status)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(viewModel.status == "Completed" ? .buttonBackground : .white)
                            }
                            Spacer()
                            if viewModel.isRunning {
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("Time")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("\(viewModel.currentStep)s")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                }
                            }
                        }
                        HStack(spacing: 12) {
                            Button(action: {
                                viewModel.startDemo()
                            }) {
                                HStack {
                                    Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                                    Text(viewModel.isRunning ? "Running..." : "Start Demo")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(viewModel.isRunning ? Color.gray : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            .disabled(viewModel.isRunning)
                            Button(action: {
                                viewModel.reset()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                    Text("Reset")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            .disabled(viewModel.isRunning)
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.black)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                    )
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}



#Preview {
    DemoMapView()
}
