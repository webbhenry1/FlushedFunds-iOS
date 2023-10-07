import Charts
import SwiftUI

struct PlayerView: View {
    
    let player: GameViewModel.UserModel
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 20) {
            Text(player.name)
                .font(.largeTitle)
                .foregroundColor(.white) // White text color
            Text("Balance: $\(player.balance, specifier: "%.2f")")
                .font(.title2)
                .foregroundColor(.white) // White text color
            if player.gameHistory.count > 1 {
                VStack(alignment: .leading) {
                    Text("Balance History")
                        .font(.title2)
                        .foregroundColor(.white) // White text color
                        .padding(.vertical)
                    GeometryReader { geometry in
                        ZStack {
                            // Background color with rounded corners
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black) // Setting background color to black
                                .frame(width: geometry.size.width, height: screenHeight()/4)

                            // Actual graph
                            LineGraph(dataPoints: player.gameHistory.suffix(5).map { $0.finishingValue })
                                .stroke(lineWidth: 2)
                                .foregroundColor(player.gameHistory.last?.finishingValue ?? 0 >= 0 ? Color.green : Color.red)
                                .frame(width: geometry.size.width * 0.9, height: screenHeight()/4 * 0.8)
                                .position(x: geometry.size.width / 2, y: screenHeight()/8)

                            // X-axis labels
                            HStack(spacing: geometry.size.width / CGFloat(min(player.gameHistory.count, 5) - 1)) {
                                ForEach(player.gameHistory.suffix(5), id: \.date) { game in
                                    Text(self.dateFormatter.string(from: game.date))
                                        .font(.caption)
                                        .foregroundColor(.white) // White text color
                                }
                            }
                            .position(x: geometry.size.width / 2, y: screenHeight()/4 - 30)
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

struct LineGraph: Shape {
    var dataPoints: [Double]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard dataPoints.count > 1 else { return path }
        
        let paddingFactor: Double = 0.1
        let paddedMax = dataPoints.max()! * (1 + paddingFactor)
        let paddedMin = dataPoints.min()! * (1 - paddingFactor)

        let yScale = (rect.height - 20) / (paddedMax - paddedMin)
        let xScale = rect.width / CGFloat(dataPoints.count - 1)
        
        path.move(to: CGPoint(x: 0, y: rect.height - (dataPoints[0] - paddedMin) * yScale))
        for i in 1..<dataPoints.count {
            path.addLine(to: CGPoint(x: xScale * CGFloat(i), y: rect.height - (dataPoints[i] - paddedMin) * yScale))
        }
        
        return path
    }
}


struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(player: GameViewModel.UserModel(name: "John Doe", balance: 1000.0))
    }
}
