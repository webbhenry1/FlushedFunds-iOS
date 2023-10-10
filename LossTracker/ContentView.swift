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
            Color(red: 8 / 255.0, green: 89 / 255.0, blue: 72 / 255.0)
                .ignoresSafeArea(.all)
            
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
        ContentView()
            .environmentObject(GameViewModel())
    }
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
