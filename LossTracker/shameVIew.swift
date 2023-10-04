import SwiftUI

struct ShameView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode

    @State var rebuyAmount: String = ""

    var body: some View {
        VStack {
            Text("Buy In")
                .foregroundColor(.white)
                .font(.largeTitle)
                .offset(y: -10)
            // First list for players in the game.
            List(gameViewModel.players.indices.filter { gameViewModel.players[$0].isSelected }, id: \.self) { index in
                HStack {
                    Text(gameViewModel.players[index].name)
                    Spacer()
                    Image(systemName: gameViewModel.players[index].isBuyingIn ? "checkmark.square" : "square")
                }.onTapGesture {
                    gameViewModel.players[index].isBuyingIn.toggle()
                }
            }
            .frame(maxHeight: 200)
            .offset(y: -10)


            // Second list for players not in the game.
            List(gameViewModel.players.indices.filter { !gameViewModel.players[$0].isSelected }, id: \.self) { index in
                HStack {
                    Text(gameViewModel.players[index].name)
                    Spacer()
                    Image(systemName: gameViewModel.players[index].isBuyingIn ? "checkmark.square" : "square")
                }.onTapGesture {
                    gameViewModel.players[index].isBuyingIn.toggle()
                }
            }
            .frame(maxHeight: 200)
            .offset(y: -10)

            
            TextField("Buy In Amount", text: $rebuyAmount)
                .keyboardType(.decimalPad)
                .padding(.top, 20)
                .padding()
            
            Button(action: {
                if let amount = Double(rebuyAmount) {
                    gameViewModel.rebuyInForPlayer(with: amount)
                    gameViewModel.sortPlayersByBuyIn() 
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    print("Invalid input for rebuy amount")
                }
            }) {
                Text("Confirm")
                    .font(.largeTitle)
                    .padding()
                    .background(Color(white: 0.9))
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
        
            .padding(.top, 20)
        }
        .onAppear(perform: resetRebuyAmount)
        .onTapGesture {
            dismissKeyboard()
        }
    }
    
    private func resetRebuyAmount() {
        rebuyAmount = ""
        gameViewModel.players.indices.forEach { gameViewModel.players[$0].isBuyingIn = false }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
