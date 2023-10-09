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
    @State private var isProcessing = false


    var body: some View {
        ZStack {
            //background
            Color(.black)
                .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [Color(red: 8 / 255.0, green: 89 / 255.0, blue: 72 / 255.0), Color(red: 4 / 255.0, green: 46 / 255.0, blue: 37 / 255.0)], startPoint:
                                                    .trailing, endPoint: .leading))
                .frame(width: 1200, height: 500)
                .rotationEffect(.degrees(225))
                .offset(y: -screenHeight()/3)
            
            VStack {
                Image("smallLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth()/1.5)
                    .padding(.bottom)
                
                VStack {
                    TextField("", text: $firstName)
                        .foregroundColor(Color.white)
                        .placeholder(when: firstName.isEmpty) {
                            Text("First Name")
                                .foregroundColor(Color.white.opacity(0.6))
                        }
                    Divider()
                        .frame(height: 2)
                        .background(Color.white)
                }
                .textFieldStyle(.plain)
                .bold()
                .padding([.top, .bottom], 10)
                
                VStack {
                    TextField("", text: $lastName)
                        .foregroundColor(Color.white)
                        .placeholder(when: lastName.isEmpty) {
                            Text("Last Name")
                                .foregroundColor(Color.white.opacity(0.6))
                        }
                    Divider()
                        .frame(height: 2)
                        .background(Color.white)
                }
                .textFieldStyle(.plain)
                .bold()
                .padding([.top, .bottom], 10)

                VStack {
                    TextField("", text: $email)
                        .foregroundColor(Color.white)
                        .placeholder(when: email.isEmpty) {
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
                    .frame(height: screenHeight()/7)
                
                Button {
                    isProcessing = true
                    registerUser()
                }label: {
                    HStack{
                        if(isProcessing){
                            Text("Registering...")
                                .italic()
                                .font(.system(size: 23))
                                .bold()
                                .foregroundColor(.white)
                                .padding(.horizontal)
                        }else {
                            Text("Register")
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
                    isRegistering.toggle()
                }) {
                    Text("Already have an account? Login")
                        .underline()
                        .foregroundColor(Color.white)
                }
            }
            .frame(width: 350)
            .padding()
        }
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
