//
//  ContentView.swift
//  LossTracker
//
//  Created by Henry Webb on 7/3/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var gameViewModel: GameViewModel

    var body: some View {
        ZStack{
            Color(red: 8 / 255.0, green: 89 / 255.0, blue: 72 / 255.0) // Set the background color
                .ignoresSafeArea(.all)
            
            TabView(selection: $selectedTab) {
                Home()
                    .environmentObject(gameViewModel)
                    .tag(0)
                Leaderboard()
                    .environmentObject(gameViewModel)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}

struct UserModel: Codable, Hashable {
    let name: String
    var balance: Double
    var buyIn: Double = 0.0
    var total: Double = 0.0
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GameViewModel())
    }
}


