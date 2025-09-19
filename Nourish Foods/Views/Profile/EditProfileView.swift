import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authViewModel: AuthViewModel
    @State private var name: String = ""
    @State private var mobile: String = ""
    @State private var dateOfBirth = Date()
    @State private var street: String = ""
    @State private var city: String = ""
    @State private var postalCode: String = ""
    @State private var country: String = "Sri Lanka"
    @State private var showingDatePicker = false
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Image Section
                    VStack(spacing: 15) {
                        Circle()
                            .fill(.white)
                            .frame(width: 100, height: 100)
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
                                                .font(.system(size: 40))
                                        }
                                    } else {
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 40))
                                    }
                                }
                            )
                        
                        Button("Change Photo") {
                            
                        }
                        .font(.subheadline)
                        .foregroundColor(.buttonBackground)
                    }
                    .padding(.top)
                    
                    // Basic Information
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Basic Information")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Full Name")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Enter your full name", text: $name)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Mobile Number")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Enter your mobile number", text: $mobile)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.phonePad)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Date of Birth")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Button(action: {
                                showingDatePicker = true
                            }) {
                                HStack {
                                    Text(dateOfBirth, style: .date)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    // Address Information
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Delivery Address")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Street Address")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Enter street address", text: $street)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 5) {
                                Text("City")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                TextField("City", text: $city)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Postal Code")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                TextField("Postal code", text: $postalCode)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .keyboardType(.numberPad)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Country")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            TextField("Country", text: $country)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    
                    // Save Button
                    Button(action: saveProfile) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.white)
                            }
                            Text(isLoading ? "Saving..." : "Save Changes")
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
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadCurrentProfile()
            }
            .sheet(isPresented: $showingDatePicker) {
                DatePickerView(selectedDate: $dateOfBirth, isPresented: $showingDatePicker)
            }
            .alert("Profile Update", isPresented: $showingAlert) {
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
        !name.isEmpty && !mobile.isEmpty
    }
    
    private func loadCurrentProfile() {
        guard let profile = authViewModel.userProfile else { return }
        
        name = profile.name
        mobile = profile.mobile
        dateOfBirth = profile.dateOfBirth ?? Date()
        
        if let address = profile.address {
            street = address.street
            city = address.city
            postalCode = address.postalCode
            country = address.country
        }
    }
    
    private func saveProfile() {
        guard let currentProfile = authViewModel.userProfile else { return }
        
        isLoading = true
        
        var updatedProfile = currentProfile
        updatedProfile.name = name
        updatedProfile.mobile = mobile
        updatedProfile.dateOfBirth = dateOfBirth
        
        // Update address
        if !street.isEmpty || !city.isEmpty || !postalCode.isEmpty {
            updatedProfile.address = UserProfile.Address(
                street: street,
                city: city,
                postalCode: postalCode,
                country: country,
                isDefault: true
            )
        }
        
        authViewModel.updateUserProfile(updatedProfile) { success in
            isLoading = false
            if success {
                alertMessage = "Profile updated successfully!"
            } else {
                alertMessage = "Failed to update profile. Please try again."
            }
            showingAlert = true
        }
    }
}

struct DatePickerView: View {
    @Binding var selectedDate: Date
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(WheelDatePickerStyle())
                .padding()
                
                Spacer()
            }
            .navigationTitle("Select Date of Birth")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    EditProfileView(authViewModel: AuthViewModel())
} 