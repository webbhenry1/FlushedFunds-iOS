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
}
