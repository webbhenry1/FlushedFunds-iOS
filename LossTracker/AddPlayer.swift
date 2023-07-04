import SwiftUI

struct AddPlayer: View {
    @State private var name: String = ""
    @State private var startingBalance: String = ""
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var gameViewModel: GameViewModel

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Starting Balance", text: $startingBalance)
                        .keyboardType(.decimalPad)
                }

                Section {
                    Button("Add") {
                        addPlayer()
                    }
                }
            }
            .navigationTitle("Add Player")
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
