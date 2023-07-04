//
//  Leaderboard.swift
//  LossTracker
//
//  Created by Henry Webb on 7/3/23.
//

import SwiftUI

struct Leaderboard: View {
    @State private var showingAddPlayer = false
    @EnvironmentObject var gameViewModel: GameViewModel

    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("Leaderboard")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .offset(x: 18)
                Spacer()
                Button(action: {
                    showingAddPlayer = true
                }) {
                    Image(systemName: "person.badge.plus")
                        .imageScale(.large) // Increase the image size
                }
                .sheet(isPresented: $showingAddPlayer) {
                    AddPlayer().environmentObject(gameViewModel)
                }
            }
            .padding() // To ensure the elements in the HStack aren't too close to the edges
            
            Rectangle()
                .frame(height: 2)
                .foregroundColor(.white)
                .padding(.horizontal)
                
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(gameViewModel.players, id: \.self) { player in
                        HStack {
                            Text(player.name)
                                .font(.title) // Increase the font size
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(player.balance, specifier: "%.2f")")
                                .font(.title) // Increase the font size
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10) // Increase the vertical padding to spread out the items
                        Divider()
                    }
                }
            }
        }
    }
}

struct Leaderboard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Leaderboard().environmentObject(GameViewModel())
        }
    }
}
