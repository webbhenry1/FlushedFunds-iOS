//
//  StartupView.swift
//  LossTracker
//
//  Created by Henry Webb on 10/6/23.
//

import SwiftUI

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
        // Implement the logic to check Firebase for an existing session.
        // For example, you can check if `Auth.auth().currentUser` is not nil.
        // If a session exists, set `isLoggedIn` to `true` and `isLoading` to `false`.
        // Otherwise, just set `isLoading` to `false` to show the Login view.
    }
}


#Preview {
    StartupView()
}
