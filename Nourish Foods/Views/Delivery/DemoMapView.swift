////
////  DemoMapView.swift
////  Nourish Foods
////
////  Created by Guest User on 2025-07-09.
////
//
//import SwiftUI
//import MapKit
//
//struct DemoMapView: View {
//    @StateObject private var viewModel = DemoMapViewModel()
//    @EnvironmentObject var cartViewModel: CartViewModel
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
//        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//    )
//    
//    var body: some View {
//        ZStack {
//            // Full screen map
//            if let current = viewModel.currentLocation, let pickup = viewModel.pickupLocation {
//                Map(coordinateRegion: Binding(
//                    get: {
//                        MKCoordinateRegion(
//                            center: current,
//                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//                        )
//                    }, set: { newRegion in
//                        region = newRegion
//                    }),
//                    annotationItems: [
//                        MapPinItem(coordinate: current, color: .red, title: "Destination"),
//                        MapPinItem(coordinate: pickup, color: .green, title: "Pickup")
//                    ]) { item in
//                        MapAnnotation(coordinate: item.coordinate) {
//                            Circle()
//                                .fill(item.color)
//                                .frame(width: 20, height: 20)
//                                .overlay(Text(item.title.prefix(1)).foregroundColor(.white).font(.caption))
//                        }
//                    }
//                    .ignoresSafeArea()
//            } else {
//                ProgressView("Loading map...")
//                    .ignoresSafeArea()
//            }
//            
//            // Bottom overlay with status
//            VStack {
//                Spacer()
//                
//                // Status overlay
//                VStack(spacing: 16) {
//                    HStack {
//                        VStack(alignment: .leading, spacing: 4) {
//                            Text("Delivery Status")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            Text(viewModel.status)
//                                .font(.title2)
//                                .fontWeight(.bold)
//                                .foregroundColor(viewModel.status == "Completed" ? .buttonBackground : .white)
//                        }
//                        Spacer()
//                        
//                        if viewModel.isRunning {
//                            VStack(alignment: .trailing, spacing: 4) {
//                                Text("Time")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                                Text("\(viewModel.currentStep)s")
//                                    .font(.title2)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.green)
//                            }
//                        }
//                    }
//                    
//                    // Action buttons
//                    HStack(spacing: 12) {
//                        Button(action: {
//                            viewModel.startDemo()
//                        }) {
//                            HStack {
//                                Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
//                                Text(viewModel.isRunning ? "Running..." : "Start Demo")
//                            }
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 12)
//                            .background(viewModel.isRunning ? Color.gray : Color.green)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                        }
//                        .disabled(viewModel.isRunning)
//                        
//                        Button(action: {
//                            viewModel.reset()
//                        }) {
//                            HStack {
//                                Image(systemName: "arrow.clockwise")
//                                Text("Reset")
//                            }
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 12)
//                            .background(Color.black)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                        }
//                        .disabled(viewModel.isRunning)
//                    }
//                }
//                .padding(20)
//                .background(
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(Color.black)
//                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
//                )
//                .padding(.horizontal, 20)
//            }
//        }
//    }
//}
//
//
//#Preview {
//    DemoMapView()
//}
