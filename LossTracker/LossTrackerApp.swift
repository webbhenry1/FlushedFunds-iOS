//
//  LossTrackerApp.swift
//  LossTracker
//
//  Created by Henry Webb on 7/3/23.
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAuth


@main
struct LossTrackerApp: App {
    @ObservedObject private var firebaseInit = FirebaseInitializer()
    @EnvironmentObject var time_manage: GameViewModel.TimerClass
    let persistenceController = PersistenceController.shared
    let gameViewModel = GameViewModel()
    
    var body: some Scene {
        WindowGroup {
            StartupView()
                .environmentObject(GameViewModel.TimerClass())
                .environmentObject(gameViewModel)
        }

    }
    
    class FirebaseInitializer: ObservableObject {
        init() {
            FirebaseApp.configure()
        }
    }


}
