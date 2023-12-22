import Charts
import SwiftUI

struct GameBalance: Identifiable {
    var date: String
    var balance: Double
    var id = UUID()
}

struct BalanceChart: View {
    var data: [GameBalance]
    
    var body: some View {
        Chart {
            ForEach(data) { game in
                LineMark(  // Using LineMark instead of BarMark
                    x: .value("Date", game.date),
                    y: .value("Balance", game.balance)
//                    stepped: false
                )
            }
        }
    }
}

struct PlayerView: View {
    @State private var profileImage: UIImage?
    @State private var isImagePickerPresented: Bool = false
    
    let player: GameViewModel.UserModel
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a'\n'dd/MM"  // HH:MM AM/PM and then date below
        return formatter
    }()

    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Image("pokerBackground")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth()/1.5, height: screenWidth()/1.5)
                
                Image("defaultProfile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: screenWidth()/2.5, height: screenWidth()/2.5)
                    .clipShape(Circle())
                    
            }
            Text(player.name)
                .font(.largeTitle)
                .foregroundColor(.white)
            Text("Balance: $\(player.balance, specifier: "%.2f")")
                .font(.title2)
                .foregroundColor(.white)
            if player.gameHistory.count > 1 {
                VStack(alignment: .center) {
                    Text("Balance History")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.vertical)
                    GeometryReader { geometry in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                                .frame(width: geometry.size.width, height: screenHeight()/4)
                            
                            // Using BalanceChart instead of LineGraph
                            BalanceChart(data: player.gameHistory.suffix(5).map { GameBalance(date: dateFormatter.string(from: $0.date), balance: $0.finishingBalance) })
                                .frame(width: geometry.size.width * 0.9, height: screenHeight()/4 * 0.8)
                                .position(x: geometry.size.width / 2, y: screenHeight()/8)
                        }
                        .frame(height: 220)
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding()
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(player: GameViewModel.UserModel(name: "John Doe", balance: 1000.0))
    }
}

