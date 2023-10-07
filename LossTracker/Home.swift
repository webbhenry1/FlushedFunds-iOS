import SwiftUI

struct Home: View {
    @State private var showingPlayerSelection = false
    @State private var showingGameStart = false
    @State private var showingGameView = false
    @State private var showingShameView = false
    @State private var showingFinishedView = false
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var time_manage: GameViewModel.TimerClass

    var body: some View {
        VStack {
            Image("largeLogo")
                .resizable() // Make it resizable
                .aspectRatio(contentMode: .fit) // Maintain aspect ratio
                .scaleEffect(0.6) // Scale the image to half its original size
                .offset(y: -150)
            Spacer()
                .frame(height: screenHeight()/10)
            Button(action: {
                showingPlayerSelection = true
            }) {
                Text("New Game")
                    .font(.largeTitle)
                    .padding(20)
                    .background(Color(white: 0.9))
                    .foregroundColor(.black)
                    .cornerRadius(15)
            }
            .sheet(isPresented: $showingPlayerSelection, onDismiss: {
            }) {
                PlayerSelectView(showingGameStart: $showingGameStart)
                    .environmentObject(gameViewModel)
                    .environmentObject(time_manage)
            }
            .padding()
            
            .sheet(isPresented: $showingGameStart, onDismiss: {
                if !gameViewModel.players.filter({ $0.isSelected }).isEmpty {
                    showingGameView = true
                }
            }) {
                startGame(showingGameView: $showingGameView)
                    .environmentObject(gameViewModel)
                    .environmentObject(time_manage)
            }
            
            .sheet(isPresented: $showingGameView) {
                gameView(showingGameView: self.$showingGameView)
                    .environmentObject(gameViewModel)
                    .environmentObject(time_manage)
            }
           .onChange(of: showingGameView) { newValue in
               if !newValue {
                   showingFinishedView = true
               }
           }
           .sheet(isPresented: $showingFinishedView) {
               FinishedView().environmentObject(gameViewModel)
           }
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home().environmentObject(GameViewModel())
    }
}
