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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(gameViewModel)

        }
    }
}
