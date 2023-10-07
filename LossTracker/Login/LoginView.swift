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



struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    
    @Binding var isLoading: Bool
    @Binding var isLoggedIn: Bool
    @Binding var isRegistering: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Email", text: $username)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
            
            Button(action: {
                loginUser()
            }) {
                Text("Login")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5.0)
            }
            
            Button(action: {
                isRegistering = true
            }) {
                Text("Don't have an account? Register")
                    .underline()
            }
            
        }
        .padding()
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
