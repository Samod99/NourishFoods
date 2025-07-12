import SwiftUI

struct AdminView: View {
    @StateObject private var dataInitializationVM = DataInitializationViewModel()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var databaseStatus: (hasRestaurants: Bool, hasProducts: Bool) = (false, false)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Database Status
                VStack(alignment: .leading, spacing: 10) {
                    Text("Database Status")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack {
                        Image(systemName: databaseStatus.hasRestaurants ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(databaseStatus.hasRestaurants ? .green : .red)
                        Text("Restaurants: \(databaseStatus.hasRestaurants ? "Available" : "Empty")")
                    }
                    
                    HStack {
                        Image(systemName: databaseStatus.hasProducts ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(databaseStatus.hasProducts ? .green : .red)
                        Text("Food Products: \(databaseStatus.hasProducts ? "Available" : "Empty")")
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // Action Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        Task {
                            await dataInitializationVM.initializeSampleDataIfNeeded()
                            await refreshDatabaseStatus()
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Sample Data")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(dataInitializationVM.isInitializing)
                    
                    Button(action: {
                        showingAlert = true
                        alertMessage = "Are you sure you want to reset all data? This action cannot be undone."
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise.circle.fill")
                            Text("Reset All Data")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(dataInitializationVM.isInitializing)
                    
                    Button(action: {
                        Task {
                            await refreshDatabaseStatus()
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Refresh Status")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(dataInitializationVM.isInitializing)
                }
                
                // Loading Indicator
                if dataInitializationVM.isInitializing {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text(dataInitializationVM.initializationMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Admin Panel")
            .navigationBarTitleDisplayMode(.large)
            .alert("Confirm Reset", isPresented: $showingAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Reset", role: .destructive) {
                    Task {
                        await dataInitializationVM.resetToSampleData()
                        await refreshDatabaseStatus()
                    }
                }
            } message: {
                Text(alertMessage)
            }
            .task {
                await refreshDatabaseStatus()
            }
        }
    }
    
    private func refreshDatabaseStatus() async {
        databaseStatus = await dataInitializationVM.checkDatabaseStatus()
    }
}

#Preview {
    AdminView()
} 