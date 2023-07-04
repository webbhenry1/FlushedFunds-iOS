//
//  endGame.swift
//  LossTracker
//
//  Created by Henry Webb on 7/3/23.
//

import SwiftUI

struct endGame: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            List {
                ForEach(gameViewModel.players.indices, id: \.self) { index in
                    HStack {
                        Text(gameViewModel.players[index].name)
                        Spacer()
                        TextField("Earnings", value: $gameViewModel.players[index].total, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                    }
                }
            }

            Button(action: endGame) {
                Text("Finish")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    private func endGame() {
        for index in gameViewModel.players.indices {
            gameViewModel.players[index].balance += gameViewModel.players[index].total
            gameViewModel.players[index].total = 0.0
        }
        gameViewModel.savePlayers()
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct endGame_Previews: PreviewProvider {
    static var previews: some View {
        endGame()
            .environmentObject(GameViewModel())
    }
}
