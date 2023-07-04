import SwiftUI

struct Home: View {
    @State private var showingGameStart = false
    @State private var showingGameEnd = false
    @EnvironmentObject var gameViewModel: GameViewModel

    var body: some View {
        VStack {
            Button(action: {
                showingGameStart = true
            }) {
                Text("Start Game")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showingGameStart) {
                startGame()
            }
            .padding()

            Button(action: {
                showingGameEnd = true
            }) {
                Text("End Game")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showingGameEnd) {
                endGame()
            }
            .padding()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(GameViewModel())
    }
}
