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
    @Binding var showingGameStart: Bool // add this line

    var body: some View {
        VStack {
            List {
                ForEach(gameViewModel.players.indices, id: \.self) { index in
                    Button(action: {
                        gameViewModel.players[index].isSelected.toggle()
                    }) {
                        HStack {
                            Text(gameViewModel.players[index].name)
                            Spacer()
                            Image(systemName: gameViewModel.players[index].isSelected ? "checkmark.square" : "square")
                        }
                    }
                }
            }
            .onAppear(perform: resetSelection) // add this line

            Button(action: {
               showingGameStart = true // add this line
               presentationMode.wrappedValue.dismiss()
           }) {
               Text("Continue")
                   .font(.largeTitle)
                   .padding()
                   .background(Color.blue)
                   .foregroundColor(.white)
                   .cornerRadius(10)
           }
        }
    }
    
    // add this function
    private func resetSelection() {
        for index in gameViewModel.players.indices {
            gameViewModel.players[index].isSelected = false
        }
    }
}
