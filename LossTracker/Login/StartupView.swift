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
    @ObservedObject var gameViewModel = GameViewModel()

    @State private var isLoading = true
    @State private var isLoggedIn = false
    @State private var isRegistering = false

    var body: some View {
        Group {
            if isLoading  {
                LoadingView(isLoadingCompleted: $isLoading)
                    .onAppear {
                        // First, check if we have a user logged in and fetch additional user data if needed
                        if Auth.auth().currentUser != nil {
                            gameViewModel.fetchCurrentUser()
                            self.isLoggedIn = true
                        } else {
                            self.isLoggedIn = false
                        }
                        
                        // Then, delay the dismissal of the loading screen to show it for a minimum amount of time
                        if !self.isLoggedIn {
                            // If the user is not logged in after fetching, set registering to true
                            self.isRegistering = true
                            
                        }
                    }
            } else if (isRegistering || !isLoggedIn) || (gameViewModel.showLoginView) {
                // If not registered or not logged in, show login view
                LoginView(isLoading: $isLoading, isLoggedIn: $isLoggedIn, isRegistering: $isRegistering)
            } else {
                // User is logged in and registered, show the main content view
                ContentView()
                    .environmentObject(gameViewModel)
                    .environmentObject(time_manage)
            }
        }
    }
}



#Preview {
    StartupView()
}
