//
//  LossTrackerApp.swift
//  LossTracker
//
//  Created by Henry Webb on 7/3/23.
//

import SwiftUI

@main
struct LossTrackerApp: App {
    let persistenceController = PersistenceController.shared
    let gameViewModel = GameViewModel()
    
    

    @EnvironmentObject var time_manage: GameViewModel.TimerClass



    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(gameViewModel)
                .environmentObject(GameViewModel.TimerClass())

        }
    }
}
