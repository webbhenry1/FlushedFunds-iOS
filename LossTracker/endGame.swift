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
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Finish")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

        }
        .onAppear {
            for index in gameViewModel.players.indices {
                gameViewModel.players[index].total = ""
            }
        }
        .onTapGesture {
            // This will make the keyboard disappear when tapping anywhere on the screen that isn't the TextField
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

struct endGame_Previews: PreviewProvider {
    static var previews: some View {
        endGame()
            .environmentObject(GameViewModel())
    }
}
