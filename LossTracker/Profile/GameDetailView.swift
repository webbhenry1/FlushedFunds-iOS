//
//  GameDetailView.swift
//  LossTracker
//
//  Created by Henry Webb on 10/9/23.
//

import SwiftUI

struct GameDetailView: View {
    let game: GameViewModel.Game
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var players: [GameViewModel.UserModel] = []

    var body: some View {
        VStack {
            // Back Button
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }
                .padding(.leading)
                
                Spacer()
                
                Text("Game from \(game.date, formatter: DateFormatter.shortDate)")
                    .font(.title2)
                    .bold()
                
                Spacer()
            }
            .padding(.top)
            
            Divider()

            VStack(alignment: .leading) {
                Text("Winnings: \(game.total, specifier: "%.2f")")
                    .font(.headline)
                    .padding(.top)
                
                Text("Finishing Balance: \(game.finishingBalance, specifier: "%.2f")")
                    .font(.headline)
                    .padding(.top)
                
                Text("Total Pool: \(game.totalPool, specifier: "%.2f")")
                    .font(.headline)
                    .padding(.top)
            }
            .padding()

            Divider()

            Text("Players")
                .font(.title)
                .bold()
                .padding(.top)

            List {
                ForEach(players) { player in
                    VStack(alignment: .leading) {
                        Text(player.name)
                            .font(.headline)
                        
                        Text("Balance: \(player.balance, specifier: "%.2f")")
                    }
                }
            }
            .onAppear {
                fetchPlayers()
            }
            
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
    
    func fetchPlayers() {
        // Implement your logic here to fetch the players' data using the UIDs from game.playersUIDs
        // and update the @State var players
    }
}

extension DateFormatter {
    static var shortDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}



