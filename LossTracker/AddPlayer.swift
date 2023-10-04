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
                            .font(.title2)
                        TextField("Starting Balance", text: $startingBalance)
                            .keyboardType(.numbersAndPunctuation)
                            .font(.title2)
                    }

                    Section {
                        Button(action: addPlayer) {
                            Text("Add")
                                .font(.title2)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func addPlayer() {
        // Remove any unwanted characters (not digits or "-")
        let filteredBalance = startingBalance.filter { "0123456789-".contains($0) }
        
        // Check if balance contains "-"
        let containsMinus = filteredBalance.contains("-")

        // Ensure the balance is not empty and only has "-" at the start
        guard !filteredBalance.isEmpty,
              !containsMinus || (filteredBalance.filter({ String($0) == "-" }).count <= 1 &&
                                 filteredBalance.first(where: { String($0) == "-" }) == filteredBalance.first) else {
            return
        }
        
        guard let startingBalance = Double(filteredBalance) else { return }

        let newPlayer = GameViewModel.UserModel(name: name, balance: startingBalance)
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
