//
//  GameViewModel.swift
//  LossTracker
//
//  Created by Henry Webb on 7/3/23.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published var players: [UserModel] = []
    @Published var timer = TimerClass()

    
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
            print("Starting a game for \(playerName) with buyIn: \(buyIn)")
            if let index = players.firstIndex(where: { $0.name == playerName }) {
                saveGameHistory(player: players[index], buyIn: buyIn, total: 0)
                players[index].balance -= buyIn
                players[index].buyIn = String(buyIn)
            }
        }
        savePlayers()
        timer.start()
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
        for index in players.indices {
            let player = players[index]
            if !player.isSelected {
                continue
            } else {
                if let total = Double(player.total) {
                    players[index].balance += total
                    saveGameHistory(player: player, buyIn: Double(player.buyIn) ?? 0, total: total)
                }
            }
        }
        savePlayers()
        print("Ending endGame function. Final state of players: \(players)")
    }


    func saveGameHistory(player: UserModel, buyIn: Double, total: Double) {
        if let index = players.firstIndex(where: { $0.name == player.name }) {
            if buyIn > 0 {
                print("Adding a new game record for \(player.name)")
                players[index].gameHistory.append(Game(buyIn: buyIn, total: 0, finishingValue: 0, date: Date()))
            } else if total > 0, !players[index].gameHistory.isEmpty {
                print("Updating game record for \(player.name)")
                players[index].gameHistory[players[index].gameHistory.count - 1].total = total
                players[index].gameHistory[players[index].gameHistory.count - 1].finishingValue = player.balance + total
                players[index].gameHistory[players[index].gameHistory.count - 1].date = Date()
            }
        }
        savePlayers()
    }



    var biggestWinner: UserModel? {
        let selectedPlayersWithGain = players.filter { $0.isSelected && (Double($0.total) ?? 0) > (Double($0.buyIn) ?? 0) }
        return selectedPlayersWithGain.max { a, b in
            (Double(a.total) ?? 0.0) - (Double(a.buyIn) ?? 0.0) < (Double(b.total) ?? 0.0) - (Double(b.buyIn) ?? 0.0)
        }
    }

    var biggestLoser: UserModel? {
        let selectedPlayersWithLoss = players.filter { $0.isSelected && (Double($0.total) ?? 0) < (Double($0.buyIn) ?? 0) }
        return selectedPlayersWithLoss.min { a, b in
            (Double(a.total) ?? 0.0) - (Double(a.buyIn) ?? 0.0) < (Double(b.total) ?? 0.0) - (Double(b.buyIn) ?? 0.0)
        }
    }

    var biggestPercentageGain: UserModel? {
        let selectedPlayersWithGain = players.filter { $0.isSelected && (Double($0.total) ?? 0) > (Double($0.buyIn) ?? 0) }
        return selectedPlayersWithGain.max { a, b in
            percentageGain(player: a) < percentageGain(player: b)
        }
    }

    var biggestPercentageLoss: UserModel? {
        let selectedPlayersWithLoss = players.filter { $0.isSelected && (Double($0.total) ?? 0) < (Double($0.buyIn) ?? 0) }
        return selectedPlayersWithLoss.min { a, b in
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
    
    var buyInSort: [UserModel] {
        return players.sorted { $0.buyIn > $1.buyIn }
    }
    
    struct Game: Codable, Hashable {
        var buyIn: Double
        var total: Double
        var finishingValue: Double
        var date: Date
    }

    struct UserModel: Codable, Hashable, Identifiable {
        var id = UUID()  
        let name: String
        var balance: Double
        var buyIn: String = ""
        var total: String = "0"
        var gameHistory: [Game] = []
        var isSelected: Bool = false
        var isBuyingIn: Bool = false
    }
    
    func rebuyInForPlayer(with amount: Double) {
        for index in players.indices where players[index].isBuyingIn {
            players[index].balance -= amount
            if let buyIn = Double(players[index].buyIn) {
                players[index].buyIn = String(buyIn + amount)
            } else {
                players[index].buyIn = String(amount)
            }
            players[index].isBuyingIn = false
            if !players[index].isSelected {
                players[index].isSelected = true
                // If they're buying back in, add to their game history.
                saveGameHistory(player: players[index], buyIn: amount, total: 0)
            }
        }
        savePlayers()
    }

    
    func sortPlayersByBuyIn() {
        players = players.sorted { Double($0.buyIn) ?? 0 > Double($1.buyIn) ?? 0 }
    }
    func sortPlayersAlphabetically() {
        self.players.sort { $0.name < $1.name }
    }
    
    class TimerClass: ObservableObject {
        @Published public var seconds_passed = 0
        @Published public var mins_passed = 0
        @Published public var final_mins = 0
        @Published public var final_secs = 0
        @Published public var final_frac = 0
        @Published public var fractional_second = 0
        @Published public var total_seconds = 0 
        var timer = Timer()
        var isPaused = true

        func start() {
            seconds_passed = 0
            fractional_second = 0
            total_seconds = 0
            if isPaused {
                isPaused = false
                timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
                    self.total_seconds += 1
                    if self.fractional_second < 99 {
                        self.fractional_second += 1
                    } else {
                        self.fractional_second = 0
                        if self.seconds_passed < 59 {
                            self.seconds_passed += 1
                        } else {
                            self.mins_passed += 1
                            self.seconds_passed = 0
                        }
                    }
                }
            }
        }

        
        func end() {
            final_mins = self.mins_passed
            final_secs = self.seconds_passed
            final_frac = self.fractional_second
            self.mins_passed = 0
            self.seconds_passed = 0
            self.fractional_second = 0
            timer.invalidate()
            isPaused = true
        }
        

    }

}
