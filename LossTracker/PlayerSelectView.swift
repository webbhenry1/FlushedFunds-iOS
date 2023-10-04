//
//  PlayerSelectView.swift
//  LossTracker
//
//  Created by Henry Webb on 7/8/23.
//

import SwiftUI
struct PlayerSelectView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var showingGameStart: Bool
    @State private var selectedPlayerExists = false

    var body: some View {
        VStack {
            List {
                ForEach(gameViewModel.players, id: \.self) { player in
                    Button(action: {
                        if let index = gameViewModel.players.firstIndex(where: { $0.name == player.name }) {
                            gameViewModel.players[index].isSelected.toggle()
                            selectedPlayerExists = gameViewModel.players.contains { $0.isSelected }
                        }
                    }) {
                        HStack {
                            Text(player.name)
                            Spacer()
                            Image(systemName: player.isSelected ? "checkmark.square" : "square")
                        }
                    }
                }
            }
            .onAppear(perform: resetSelection)

            Button(action: {
                if gameViewModel.players.filter({ $0.isSelected }).isEmpty {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    showingGameStart = true
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Continue")
                    .font(.largeTitle)
                    .padding()
                    .background(Color(white: 0.9))
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }

        }
        .onAppear {
            gameViewModel.sortPlayersAlphabetically()
            resetSelection()
        }

    }
    
    private func resetSelection() {
        for index in gameViewModel.players.indices {
            gameViewModel.players[index].isSelected = false
        }
        selectedPlayerExists = false 
    }
}
