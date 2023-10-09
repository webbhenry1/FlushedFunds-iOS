//
//  StartupView.swift
//  LossTracker
//
//  Created by Henry Webb on 10/6/23.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct StartupView: View {
    @EnvironmentObject var time_manage: GameViewModel.TimerClass
    
    let persistenceController = PersistenceController.shared
    let gameViewModel = GameViewModel()
    
    @State private var isLoading = true
    @State private var isLoggedIn = false
    @State private var isRegistering = false

    var body: some View {
        Group {
            if isLoading {
                LoadingView(isLoadingCompleted: $isLoading)
            } else if isRegistering {
                RegisterView(isRegistering: $isRegistering)
            } else if !isLoggedIn {
                LoginView(isLoading: $isLoading, isLoggedIn: $isLoggedIn, isRegistering: $isRegistering)
            } else {
                ContentView()
                    .environmentObject(gameViewModel)
                    .environmentObject(time_manage)
            }
        }
        .onAppear {
            checkForExistingSession()
        }
    }

    func checkForExistingSession() {
        if Auth.auth().currentUser != nil {
            // User is logged in, so update the relevant state property
            self.isLoggedIn = true
            self.isLoading = false
        } else {
            // No user is logged in
            self.isLoading = false
        }
    }

}


#Preview {
    StartupView()
}
