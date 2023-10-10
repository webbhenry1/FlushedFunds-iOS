//
//  GameHistoryView.swift
//  LossTracker
//
//  Created by Henry Webb on 10/9/23.
//
import Foundation
import SwiftUI

struct GameHistoryView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                .padding(.top)
                
                Text("Game History")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(.top)
                
                let allGames = viewModel.players.flatMap { $0.gameHistory }

                ScrollView {
                    ForEach(allGames.sorted(by: { $0.date > $1.date }), id: \.self) { game in
                        NavigationLink(destination: GameDetailView(game: game)) {
                            VStack(alignment: .leading) {
                                Text("Game from \(game.date)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text("Winnings: \(game.finishingBalance , specifier: "%.2f")")
                                    .foregroundColor(.white)
                                
                                Text("Balance: \(game.total , specifier: "%.2f")")
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.green.opacity(0.7))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle()) // Remove default button coloring
                    }
                }

                .padding(.top)
            }
            .padding()
        }
    }
}

//#Preview {
//    GameHistoryView()
//
//}
