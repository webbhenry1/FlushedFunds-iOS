//
//  LoginView.swift
//  LossTracker
//
//  Created by Henry Webb on 10/6/23.
//

import Foundation
import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import AuthenticationServices



struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    @Binding var isLoading: Bool
    @Binding var isLoggedIn: Bool
    @Binding var isRegistering: Bool
    @State private var isProcessing = false

    
    var body: some View {
        ZStack{
            //background
            Color(.black)
                .ignoresSafeArea()
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [Color(red: 8 / 255.0, green: 89 / 255.0, blue: 72 / 255.0), Color(red: 4 / 255.0, green: 46 / 255.0, blue: 37 / 255.0)], startPoint:
                        .leading, endPoint: .trailing))
                .frame(width: 1200, height: 500)
                .rotationEffect(.degrees(135))
                .offset(y: -screenHeight()/3)
            
            
            VStack() {
                Image("smallLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth()/1.5)
                    .offset(y:  -screenHeight()/21)

                // Email TextField
                VStack {
                    TextField("", text: $username)
                        .foregroundColor(Color.white)
                        .placeholder(when: username.isEmpty) {
                            Text("Email")
                                .foregroundColor(Color.white.opacity(0.6))
                        }
                    Divider()
                        .frame(height: 2)
                        .background(Color.white)
                }
                .textFieldStyle(.plain)
                .bold()
                .padding([.top, .bottom], 10)

                // Password SecureField
                VStack {
                    SecureField("", text: $password)
                        .foregroundColor(Color.white)
                        .placeholder(when: password.isEmpty) {
                            Text("Password")
                                .foregroundColor(Color.white.opacity(0.6))
                        }
                    Divider()
                        .frame(height: 2)
                        .background(Color.white)
                }
                .textFieldStyle(.plain)
                .bold()
                .padding([.top, .bottom], 10)
                
                Spacer()
                    .frame(height: screenHeight()/5)
                Button {
                    isProcessing = true
                    loginUser()
                } label: {
                    HStack{
                        if(isProcessing){
                            Text("Logging In...")
                                .italic()
                                .font(.system(size: 23))
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        }else {
                            Text("Log In")
                                .font(.system(size: 23))
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                    .frame(width: screenWidth()/1.8, height: screenHeight()/18)
                    .background(Color(red: 8 / 255.0, green: 89 / 255.0, blue: 72 / 255.0))
                    .cornerRadius(10)
                    .shadow(color: .black, radius: 0, y: 5)
                    
                }
                
                Spacer()
                    .frame(height: screenHeight()/30)
                
                Button(action: {
                    isRegistering = true
                }) {
                    Text("Don't have an account? Register")
                        .underline()
                        .foregroundColor(Color.white)
                }
                
            }
            .frame(width: 350)
            .padding()
        }
        
    }
    func loginUser() {
        Auth.auth().signIn(withEmail: username, password: password) { authResult, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                return
            }
            
            // Successful login
            self.isLoggedIn = true
            print("Logged in successfully!")
        }
    }
}



#Preview {
    LoginView(isLoading: .constant(false), isLoggedIn: .constant(false), isRegistering: .constant(false))
}
