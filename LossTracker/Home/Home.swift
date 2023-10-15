import SwiftUI

struct Home: View {
    @State private var showingPlayerSelection = false
    @State private var showingGameStart = false
    @State private var showingGameView = false
    @State private var showingShameView = false
    @State private var showingFinishedView = false
    @State private var showingProfileView = false
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var time_manage: GameViewModel.TimerClass

    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button(action: {
                    showingProfileView.toggle()
                }) {
                    Image(systemName: "person.circle")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: screenWidth()/10, height: screenWidth()/10)
                }
                .sheet(isPresented: $showingProfileView) {
                    profileView()
                }
            }
            .offset(y: -screenHeight()/9)
            .padding()
            Spacer()
                .frame(height: screenHeight()/2)
            Button(action: {
                showingPlayerSelection = true
            }) {
                Text("New Game")
                    .shadow(color: .black, radius: 0.5, x: 1, y: 1)
                    .font(.system(size: screenWidth()/10))
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
