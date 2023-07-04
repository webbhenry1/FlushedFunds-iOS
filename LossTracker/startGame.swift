//
//  startGame.swift
//  LossTracker
//
//  Created by Henry Webb on 7/3/23.
//

import SwiftUI

struct startGame: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            List {
                ForEach(gameViewModel.players.indices, id: \.self) { index in
                    HStack {
                        Text(gameViewModel.players[index].name)
                        Spacer()
                        TextField("Buy-in", value: $gameViewModel.players[index].buyIn, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                    }
                }
            }

            Button(action: startGame) {
                Text("Go")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    private func startGame() {
        for index in gameViewModel.players.indices {
            gameViewModel.players[index].balance -= gameViewModel.players[index].buyIn
            gameViewModel.players[index].buyIn = 0.0
        }
        gameViewModel.savePlayers()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct startGame_Previews: PreviewProvider {
    static var previews: some View {
        startGame()
            .environmentObject(GameViewModel())
    }
}
