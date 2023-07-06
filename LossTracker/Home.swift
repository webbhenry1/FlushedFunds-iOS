import SwiftUI

struct Home: View {
    @State private var showingGameStart = false
    @State private var showingGameEnd = false
    @State private var showingFinishedView = false
    @EnvironmentObject var gameViewModel: GameViewModel

    var body: some View {
        VStack {
            Image("White_Logo")
                .resizable() // Make it resizable
                .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                .scaleEffect(0.4) // Scale the image to half its original size
                .offset(y: -150)
            
            Button(action: {
                showingGameStart = true
            }) {
                Text("Start Game")
                    .font(.largeTitle)
                    .padding(20)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .offset(y: -100)

            .sheet(isPresented: $showingGameStart) {
                startGame()
            }
            .padding()

            Button(action: {
                showingGameEnd = true
            }) {
                Text("End Game")
                    .font(.largeTitle)
                    .padding(24)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .offset(y: -100)
            .sheet(isPresented: $showingGameEnd, onDismiss: {
                showingFinishedView = true
            }) {
                endGame()
            }
            .padding()

            .sheet(isPresented: $showingFinishedView) {
                FinishedView()
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(GameViewModel())
    }
}
