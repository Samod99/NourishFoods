//
//  SignupView.swift
//  Nourish Foods
//
//  Created by Guest User on 2025-07-05.
//

import SwiftUI

struct SignupView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var mobile: String = ""
    @State private var password: String = ""
    @State private var navigateSign: Bool = false
    @State private var navigateHome: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Spacer()
                VStack{
                    Spacer()
                    VStack{
                        Text("Nourish Foods")
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundColor(.white)
                        Text("Best food delivery service")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                            .opacity(0.7)
                    }
                    .padding(.top)
                    VStack{
                        TextField("Name", text: $name)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        TextField("Email", text: $email)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        TextField("Mobile", text: $mobile)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        SecureField("Password", text: $password)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        if let error = authViewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        if authViewModel.isLoading {
                            ProgressView()
                        }
                        Button {
                            authViewModel.signup(name: name, email: email, mobile: mobile, password: password)
                        } label: {
                            HStack{
                                Spacer()
                                Text("Register Now")
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
                        HStack{
                            Spacer()
                            Text("Do you have an account?")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                                .font(.system(size: 16))
                                .opacity(0.7)
                            Text("Sign In")
                                .underline()
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .font(.system(size: 16))
                                .onTapGesture {
                                    navigateSign = true
                                }
                            Spacer()
                        }
                        .padding(.top,10)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    Spacer()
                }
                // NavigationLinks
                NavigationLink(destination: LoginView(), isActive: $navigateSign) {
                    EmptyView()
                }
                .hidden()
                NavigationLink(destination: HomeView(), isActive: $navigateHome) {
                    EmptyView()
                }
                .hidden()
            }
            .frame(maxWidth: .infinity , maxHeight: .infinity)
            .background(Color.buttonBackground)
            .ignoresSafeArea()
            .onChange(of: authViewModel.isAuthenticated) { isAuth in
                if isAuth {
                    navigateHome = true
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignupView()
}
