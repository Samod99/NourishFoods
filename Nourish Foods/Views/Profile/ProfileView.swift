//
//  ProfileView.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-07.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var cartViewModel: CartViewModel
    @State private var showingSignOutAlert = false
    @State private var showingNotificationAlert = false
    @State private var showingEditProfile = false
    @State private var showingReviews = false
    @State private var showingOrderHistory = false
    @State private var notificationStatus: UNAuthorizationStatus = .notDetermined
    
    var body: some View {
        ZStack {
            VStack {
                // Profile Header
                HStack(spacing: 15) {
                    Circle()
                        .fill(.white)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Group {
                                if let profileImageURL = authViewModel.userProfile?.profileImageURL, !profileImageURL.isEmpty {
                                    AsyncImage(url: URL(string: profileImageURL)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .clipShape(Circle())
                                    } placeholder: {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 30))
                                    }
                                } else {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 30))
                                }
                            }
                        )
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(authViewModel.userProfile?.name ?? authViewModel.currentUser?.displayName ?? "User")
                            .foregroundStyle(Color.black.opacity(0.8))
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                        Text(authViewModel.userProfile?.email ?? authViewModel.currentUser?.email ?? "user@example.com")
                            .font(.system(size: 15))
                            .fontWeight(.regular)
                            .foregroundStyle(Color.black.opacity(0.5))
                        
                        if let mobile = authViewModel.userProfile?.mobile, !mobile.isEmpty {
                            Text(mobile)
                                .font(.system(size: 14))
                                .fontWeight(.regular)
                                .foregroundStyle(Color.black.opacity(0.5))
                        }
                    }
                    Spacer()
                }
                .padding()
                
                // Profile Options
                VStack(spacing: 0) {
                    ProfileOptionRow(icon: "person.fill", title: "Edit Profile", action: {
                        showingEditProfile = true
                    })
                    
                    ProfileOptionRow(icon: "bell.fill", title: "Notifications", action: {
                        handleNotificationSettings()
                    })
                    
                    ProfileOptionRow(icon: "location.fill", title: "Delivery Address", action: {
                        // TODO: Implement delivery address
                    })
                    
                    ProfileOptionRow(icon: "creditcard.fill", title: "Payment Methods", action: {
                        // TODO: Implement payment methods
                    })
                    
                    ProfileOptionRow(icon: "questionmark.circle.fill", title: "Help & Support", action: {
                        // TODO: Implement help & support
                    })
                    
                    ProfileOptionRow(icon: "info.circle.fill", title: "About", action: {
                        // TODO: Implement about
                    })
                }
                .background(Color.white)
                .cornerRadius(15)
                .padding(.horizontal)
                
                // Recent Orders Section
                if !authViewModel.userOrders.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Recent Orders")
                                .font(.headline)
                            Spacer()
                            Button("View All") {
                                showingOrderHistory = true
                            }
                            .font(.subheadline)
                            .foregroundColor(.buttonBackground)
                        }
                        .padding(.leading)
                        
                        ForEach(authViewModel.userOrders.prefix(3)) { order in
                            Button(action: {
                                print("Order tapped: \(order.id)")
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(order.date, style: .date)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        Text("Total: Rs. \(String(format: "%.2f", order.total))")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                        Text("Status: \(order.status.rawValue)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding(12)
                                .background(Color.white)
                                .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom)
                }
                
                // My Reviews Button
                Button(action: {
                    showingReviews = true
                }) {
                    HStack {
                        Image(systemName: "star.bubble.fill")
                            .foregroundColor(.yellow)
                            .frame(width: 20)
                        Text("My Reviews (\(authViewModel.userReviews.count))")
                            .foregroundColor(.black)
                            .fontWeight(.medium)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                // Sign Out Button
                Button(action: {
                    showingSignOutAlert = true
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                        Text("Sign Out")
                            .foregroundColor(.red)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: 1)
                    )
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.viewBackground)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView(authViewModel: authViewModel)
        }
        .sheet(isPresented: $showingReviews) {
            UserReviewsView(authViewModel: authViewModel)
        }
        .sheet(isPresented: $showingOrderHistory) {
            OrderHistoryView(authViewModel: authViewModel)
        }
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                authViewModel.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
        .alert("Notification Settings", isPresented: $showingNotificationAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Open Settings") {
                openAppSettings()
            }
            if notificationStatus == .denied {
                Button("Request Permission") {
                    requestNotificationPermission()
                }
            }
        } message: {
            Text(getNotificationStatusMessage())
        }
        .task {
            checkNotificationStatus()
        }
    }
    
    private func handleNotificationSettings() {
        checkNotificationStatus()
        showingNotificationAlert = true
    }
    
    private func checkNotificationStatus() {
        NotificationService.shared.checkPermissionStatus { status in
            notificationStatus = status
        }
    }
    
    private func requestNotificationPermission() {
        NotificationService.shared.requestPermission { granted in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
            checkNotificationStatus()
        }
    }
    
    private func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    private func getNotificationStatusMessage() -> String {
        switch notificationStatus {
        case .authorized:
            return "Notifications are enabled. You'll receive updates about your orders and promotions."
        case .denied:
            return "Notifications are disabled. To receive order updates and promotions, please enable notifications in Settings."
        case .notDetermined:
            return "Notification permission hasn't been requested yet. Would you like to enable notifications?"
        case .provisional:
            return "Provisional notifications are enabled. You'll receive some notifications automatically."
        case .ephemeral:
            return "Ephemeral notifications are enabled for this app."
        @unknown default:
            return "Unknown notification status."
        }
    }
}

struct ProfileOptionRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.buttonBackground)
                    .frame(width: 20)
                
                Text(title)
                    .foregroundColor(.black)
                    .fontWeight(.medium)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
        }
        .buttonStyle(PlainButtonStyle())
        
        if title != "About" {
            Divider()
                .padding(.leading, 50)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
        .environmentObject(CartViewModel())
}
