import SwiftUI

struct AddPlayer: View {
    @State private var name: String = ""
    @State private var startingBalance: String = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameViewModel: GameViewModel

    var body: some View {
        NavigationView {
            VStack {
                Text("Add Player")
                    .font(.title)
                    .padding(.bottom, 50)
                    .padding(.top, 30)
                Form {
                    Section {
                        TextField("Name", text: $name)
                            .font(.title2)  // Increase the font size of text field
                        TextField("Starting Balance", text: $startingBalance)
                            .keyboardType(.decimalPad)
                            .font(.title2)  // Increase the font size of text field
                    }

                    Section {
                        Button(action: addPlayer) {
                            Text("Add")
                                .font(.title2)  // Increase the font size of the button text
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func addPlayer() {
        guard let startingBalance = Double(startingBalance) else { return }

        let newPlayer = UserModel(name: name, balance: startingBalance)
        gameViewModel.players.append(newPlayer)
        gameViewModel.savePlayers()

        presentationMode.wrappedValue.dismiss()
    }
}

struct AddPlayer_Previews: PreviewProvider {
    static var previews: some View {
        AddPlayer().environmentObject(GameViewModel())
    }
}
