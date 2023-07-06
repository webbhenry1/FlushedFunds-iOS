//
//  GameViewModel.swift
//  LossTracker
//
//  Created by Henry Webb on 7/3/23.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published var players: [UserModel] = []
    
    init() {
        if let playersData = UserDefaults.standard.data(forKey: "players"),
           let decodedPlayers = try? JSONDecoder().decode([UserModel].self, from: playersData) {
            players = decodedPlayers
        }
    }
    
    func savePlayers() {
        if let encodedPlayers = try? JSONEncoder().encode(players) {
            UserDefaults.standard.set(encodedPlayers, forKey: "players")
        }
    }
    
    func startGame(with buyIns: [String: Double]) {
        for (playerName, buyIn) in buyIns {
            if let index = players.firstIndex(where: { $0.name == playerName }) {
                players[index].balance -= buyIn
            }
        }
        savePlayers()
    }
    
    var totalPool: Double {
        return players.reduce(0) { total, player in
            if let buyIn = Double(player.buyIn) {
                return total + buyIn
            } else {
                return total
            }
        }
    }


    var biggestWinner: UserModel? {
        return players.max { a, b in
            (Double(a.total) ?? 0.0) - (Double(a.buyIn) ?? 0.0) < (Double(b.total) ?? 0.0) - (Double(b.buyIn) ?? 0.0)
        }
    }

    var biggestLoser: UserModel? {
        return players.min { a, b in
            (Double(a.total) ?? 0.0) - (Double(a.buyIn) ?? 0.0) < (Double(b.total) ?? 0.0) - (Double(b.buyIn) ?? 0.0)
        }
    }

    var biggestPercentageGain: UserModel? {
        return players.max { a, b in
            percentageGain(player: a) < percentageGain(player: b)
        }
    }

    var biggestPercentageLoss: UserModel? {
        return players.min { a, b in
            percentageGain(player: a) < percentageGain(player: b)
        }
    }

    private func percentageGain(player: UserModel) -> Double {
        guard let buyIn = Double(player.buyIn), buyIn != 0 else { return 0.0 }
        return ((Double(player.total) ?? 0.0) - buyIn) / buyIn
    }
    
    var sortedPlayers: [UserModel] {
            return players.sorted { $0.balance > $1.balance }
        }
}
