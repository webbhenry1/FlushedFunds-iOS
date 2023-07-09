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
        print("buyIns: \(buyIns)")  
        for (playerName, buyIn) in buyIns {
            if let index = players.firstIndex(where: { $0.name == playerName }) {
                saveGameHistory(player: players[index], buyIn: buyIn, total: 0)
                players[index].balance -= buyIn
                players[index].buyIn = String(buyIn)
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
    
    func endGame() {
        print("Starting endGame function. Initial state of players: \(players)")
        
        for player in players {
            if let total = Double(player.total) {
                if let index = players.firstIndex(where: { $0.name == player.name }) {
                    saveGameHistory(player: players[index], buyIn: 0, total: total)
                    players[index].balance += total
                }
            }
        }
        savePlayers()
        
        print("Ending endGame function. Final state of players: \(players)")
    }


    func saveGameHistory(player: UserModel, buyIn: Double, total: Double) {
        if let index = players.firstIndex(where: { $0.name == player.name }) {
            if buyIn > 0 { // If it's the start of the game
                // Append a new Game with the buyIn to the gameHistory
                players[index].gameHistory.append(Game(buyIn: buyIn, total: 0))
            } else if total > 0, !players[index].gameHistory.isEmpty { // If it's the end of the game and there is at least one game in the history
                // Update the total of the current game in the gameHistory
                players[index].gameHistory[players[index].gameHistory.count - 1].total = total
            }
        }
        savePlayers()
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
    
    struct Game: Codable, Hashable {
        var buyIn: Double
        var total: Double
    }

    struct UserModel: Codable, Hashable {
        let name: String
        var balance: Double
        var buyIn: String = ""
        var total: String = ""
        var gameHistory: [Game] = []
        var isSelected: Bool = false // Add this line
    }


}
