import SwiftUI

struct endGame: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var showingGameView: Bool
    @Binding var showingFinishedView: Bool


    var body: some View {
        ZStack {
            Color(red: 8 / 255.0, green: 89 / 255.0, blue: 72 / 255.0) 
                .ignoresSafeArea(.all)
            
            VStack {
                ForEach(gameViewModel.players.indices.filter { gameViewModel.players[$0].isSelected }, id: \.self) { index in
                    HStack {
                        Text(gameViewModel.players[index].name)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 100, alignment: .leading)
                        Spacer()
                        TextField("Earnings", text: $gameViewModel.players[index].total)
                            .keyboardType(.decimalPad)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }

                Button(action: {
                    gameViewModel.endGame()
                    self.showingFinishedView = true
                    self.presentationMode.wrappedValue.dismiss()
                    self.showingGameView = false
                }) {
                    Text("Finish")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Spacer()
            }
            .padding(.top, 50)
        }
        .onAppear {
            for index in gameViewModel.players.indices where gameViewModel.players[index].isSelected {
                gameViewModel.players[index].total = ""
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}


