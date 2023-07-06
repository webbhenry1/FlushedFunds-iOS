//
//  FinishedView.swift
//  LossTracker
//
//  Created by Henry Webb on 7/5/23.
//

import SwiftUI

struct FinishedView: View {
    @EnvironmentObject var gameViewModel: GameViewModel

    var body: some View {
        List {
            Text("Total Pool: $\(gameViewModel.totalPool)")
            Text("Biggest Winner: \(gameViewModel.biggestWinner?.name ?? "N/A")")
            Text("Biggest Loser: \(gameViewModel.biggestLoser?.name ?? "N/A")")
            Text("Biggest % Gain: \(gameViewModel.biggestPercentageGain?.name ?? "N/A")")
            Text("Biggest % Loss: \(gameViewModel.biggestPercentageLoss?.name ?? "N/A")")
        }
    }
}

struct FinishedView_Previews: PreviewProvider {
    static var previews: some View {
        FinishedView()
            .environmentObject(GameViewModel())
    }
}


