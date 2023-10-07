//
//  registerView.swift
//  LossTracker
//
//  Created by Henry Webb on 10/6/23.
//


import SwiftUI
import Firebase
import FirebaseAuth


struct RegisterView: View {
    @State private var email: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var password: String = ""
    @State private var groupName: String = ""
    @Binding var isRegistering: Bool

    var body: some View {
        VStack(spacing: 20) {
            Image("yourAppLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 100)
            
            TextField("First Name", text: $firstName)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(8)
                .padding(.horizontal)
            
            TextField("Last Name", text: $lastName)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(8)
                .padding(.horizontal)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(8)
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(8)
                .padding(.horizontal)

            TextField("Group Name", text: $groupName)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(8)
                .padding(.horizontal)

            Button(action: {
                registerUser()
            }) {
                Text("Register")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            Spacer()

            Button(action: {
                isRegistering.toggle()
            }) {
                Text("Already have an account? Login")
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 50)
        .background(Color.black) 
        .edgesIgnoringSafeArea(.all)
    }

    func registerUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Registration error: \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else { return }
            
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData([
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "balance": 0.0,
                "gameHistory": [],
                "friends": []
            ]) { error in
                if let error = error {
                    print("Error writing user data to Firestore: \(error.localizedDescription)")
                    return
                }
                
                print("User registered and data saved!")
                self.isRegistering = false
            }
        }
    }
}



#Preview {
    RegisterView(isRegistering: .constant(true))
}
