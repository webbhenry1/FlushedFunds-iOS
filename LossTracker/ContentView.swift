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
    @EnvironmentObject var time_manage: GameViewModel.TimerClass


    var body: some View {
        ZStack{
            
            TabView(selection: $selectedTab) {
                Home()
                    .environmentObject(gameViewModel)
                    .environmentObject(time_manage)
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





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GameViewModel())
    }
}


