import SwiftUI

struct startGame: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var showingGameView: Bool
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            
            VStack {
                ForEach(gameViewModel.players.indices.filter { gameViewModel.players[$0].isSelected }, id: \.self) { index in
                    HStack {
                        Text(gameViewModel.players[index].name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 100, alignment: .leading)
                        
                        Spacer()
                        
                        TextField("Buy-In", text: $gameViewModel.players[index].buyIn)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                
                Button(action: {
                    var buyIns: [String: Double] = [:]

                    // Collect buy-ins from the players
                    for player in gameViewModel.players where player.isSelected {
                        if let buyInAmount = Double(player.buyIn) {
                            buyIns[player.name] = buyInAmount
                        }
                    }

                    if !buyIns.isEmpty {
                        gameViewModel.startGame(with: buyIns)
                        gameViewModel.sortPlayersByBuyIn()
                        showingGameView = true
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Go")
                        .font(.largeTitle)
                        .padding()
                        .background(Color(white: 0.9))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding()


                .padding()
                
                Spacer()
            }
            .padding(.top, 50) 
        }
        .onAppear {
            for index in gameViewModel.players.indices {
                gameViewModel.players[index].buyIn = ""
            }
            gameViewModel.sortPlayersAlphabetically()
        }

        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    private func startGame() -> Bool {
        var gameStarted = false
        for index in gameViewModel.players.indices {
            if let buyIn = Double(gameViewModel.players[index].buyIn), gameViewModel.players[index].isSelected {
                gameViewModel.players[index].balance -= buyIn
                gameStarted = true
            }
        }
        gameViewModel.savePlayers()
        return gameStarted
    }
}



