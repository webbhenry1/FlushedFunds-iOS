//
//  PlayerView.swift
//  LossTracker
//
//  Created by Henry Webb on 10/3/23.
//

import SwiftUI

struct PlayerView: View {
    let player: GameViewModel.UserModel
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()

    var body: some View {
        VStack {
            Text(player.name)
                .font(.largeTitle)
            Text("Balance: $\(player.balance, specifier: "%.2f")")
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text("Balance History")
                    .font(.title2)
                GeometryReader { geometry in
                    LineGraph(dataPoints: player.gameHistory.suffix(5).map { $0.total })
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(height: 200)
                        .padding(.horizontal)
                    
                    HStack(spacing: geometry.size.width / CGFloat(player.gameHistory.count - 1)) {
                        ForEach(player.gameHistory.suffix(5), id: \.date) { game in
                            Text(self.dateFormatter.string(from: game.date))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .padding()
    }
}



struct LineGraph: Shape {
    var dataPoints: [Double]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard dataPoints.count > 1 else { return path }

        let yScale = (rect.height - 20) / (dataPoints.max()! - dataPoints.min()!)
        let xScale = rect.width / CGFloat(dataPoints.count - 1)
        
        path.move(to: CGPoint(x: 0, y: rect.height - (dataPoints[0] - dataPoints.min()!) * yScale))
        for i in 1..<dataPoints.count {
            path.addLine(to: CGPoint(x: xScale * CGFloat(i), y: rect.height - (dataPoints[i] - dataPoints.min()!) * yScale))
        }
        
        return path
    }
}


struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(player: GameViewModel.UserModel(name: "John Doe", balance: 1000.0))
    }
}

