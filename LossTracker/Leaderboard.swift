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
    @State private var selectedPlayer: GameViewModel.UserModel?


    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack{
                HStack{
                    Spacer()
                    
                    Button(action: {
                        showingAddPlayer = true
                    }) {
                        Image(systemName: "person.badge.plus")
                            .scaleEffect(2)
                            .foregroundColor(Color(white: 0.9))
                    }
                    .sheet(isPresented: $showingAddPlayer) {
                        AddPlayer().environmentObject(gameViewModel)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(gameViewModel.sortedPlayers) { player in
                            Button(action: {
                                self.selectedPlayer = player
                            }) {
                                HStack {
                                    Text(player.name)
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
                                    Spacer()
                                    Text("$\(player.balance, specifier: "%.2f")")
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .shadow(color: .black, radius: 0.5, x: 0.5, y: 0.5)
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                                .background(Color(white: 0.9))
                                .cornerRadius(10)
                            }
                            .padding(.vertical, 5)
                            .sheet(item: $selectedPlayer) { playerToShow in
                                PlayerView(player: playerToShow)
                            }
                        }
                    }
                }
                .padding(.top)

            }
            .padding()
        }
    }
}

//Spacing for the rest of the app to use:
func screenWidth() -> CGFloat {
    return UIScreen.main.bounds.width
}

func screenHeight() -> CGFloat {
    return UIScreen.main.bounds.height
}


struct Leaderboard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Leaderboard().environmentObject(GameViewModel())
        }
    }
}

