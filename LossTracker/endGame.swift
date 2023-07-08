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
                        TextField("Earnings", text: $gameViewModel.players[index].total)
                            .keyboardType(.decimalPad)

                    }
                }
            }

            Button(action: {
                gameViewModel.endGame()
            }) {
                Text("Finish")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

        }
    }

    
}

struct endGame_Previews: PreviewProvider {
    static var previews: some View {
        endGame()
            .environmentObject(GameViewModel())
    }
}
