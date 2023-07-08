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
                        TextField("Buy-In", text: $gameViewModel.players[index].buyIn)
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
        .onAppear {
            for index in gameViewModel.players.indices {
                gameViewModel.players[index].buyIn = ""
            }
        }
        .onTapGesture {
            // This will make the keyboard disappear when tapping anywhere on the screen that isn't the TextField
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    private func startGame() {
        for index in gameViewModel.players.indices {
            if let buyIn = Double(gameViewModel.players[index].buyIn) {
                gameViewModel.players[index].balance -= buyIn
                gameViewModel.players[index].buyIn = ""
            }
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
