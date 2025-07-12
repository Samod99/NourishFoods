import SwiftUI

struct AuthenticationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showLogin = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.buttonBackground
                    .ignoresSafeArea()
                
                VStack {
                    // Header
                    VStack(spacing: 10) {
                        Text("Nourish Foods")
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Best food delivery service")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    // Authentication Forms
                    VStack(spacing: 20) {
                        // Tab Buttons
                        HStack(spacing: 0) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showLogin = true
                                }
                            }) {
                                Text("Sign In")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(showLogin ? .white : .white.opacity(0.7))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(showLogin ? Color.white.opacity(0.2) : Color.clear)
                                    )
                            }
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showLogin = false
                                }
                            }) {
                                Text("Sign Up")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(!showLogin ? .white : .white.opacity(0.7))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(!showLogin ? Color.white.opacity(0.2) : Color.clear)
                                    )
                            }
                        }
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        
                        // Form Content
                        if showLogin {
                            LoginFormView()
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                        } else {
                            SignupFormView()
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                ))
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct LoginFormView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            TextField("Email", text: $email)
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .textContentType(.password)
            
            if let error = authViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            
            if authViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.2)
            } else {
                Button(action: {
                    authViewModel.login(email: email, password: password)
                }) {
                    HStack {
                        Spacer()
                        Text("Sign In")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 18))
                        Spacer()
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                }
                .disabled(email.isEmpty || password.isEmpty)
            }
        }
    }
}

struct SignupFormView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var mobile: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            TextField("Full Name", text: $name)
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .textContentType(.name)
            
            TextField("Email", text: $email)
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            TextField("Mobile Number", text: $mobile)
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .textContentType(.telephoneNumber)
                .keyboardType(.phonePad)
            
            SecureField("Password", text: $password)
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .textContentType(.newPassword)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .textContentType(.newPassword)
            
            if let error = authViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
                    .multilineTextAlignment(.center)
            }
            
            if authViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.2)
            } else {
                Button(action: {
                    if password == confirmPassword {
                        authViewModel.signup(name: name, email: email, mobile: mobile, password: password)
                    } else {
                        authViewModel.errorMessage = "Passwords do not match"
                    }
                }) {
                    HStack {
                        Spacer()
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .font(.system(size: 18))
                        Spacer()
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                }
                .disabled(name.isEmpty || email.isEmpty || mobile.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
        }
    }
}

#Preview {
    AuthenticationView()
        .environmentObject(AuthViewModel())
} 