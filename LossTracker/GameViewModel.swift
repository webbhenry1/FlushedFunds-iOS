//
//  GameViewModel.swift
//  LossTracker
//
//  Created by Henry Webb on 7/3/23.
//

import Foundation
import Firebase
import FirebaseAuth




class GameViewModel: ObservableObject {
    @Published var players: [UserModel] = []
    @Published var timer = TimerClass()
    @Published var games: [Game] = []
    @Published var me: UserModel?
    @Published var showLoginView = false


        
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    init() {
        if let playersData = UserDefaults.standard.data(forKey: "players"),
           let decodedPlayers = try? JSONDecoder().decode([UserModel].self, from: playersData) {
            players = decodedPlayers
        }
//        fetchCurrentUser()
    }
    
    struct UserModel: Codable, Hashable, Identifiable {
        var id = UUID()
        let name: String
        var balance: Double
        var balanceHistory: [BalanceRecord] = []
        var buyIn: String = ""
        var total: String = "0"
        var gameHistory: [Game] = []
        var isSelected: Bool = false
        var isBuyingIn: Bool = false
    }
    
    struct BalanceRecord: Codable, Hashable, Identifiable {
        let id: String
        let date: Date
        let amount: Double
    }
    
    struct Game: Codable, Hashable {
        var buyIn: Double
        var total: Double
        var finishingBalance: Double
        var date: Date
        var totalPool: Double
        var playersUIDs: [String]
    }

    struct Player: Codable, Hashable {
        var uid: String
        var username: String
    }
    
    func fetchCurrentUser() {
        if let user = Auth.auth().currentUser {
            let docRef = db.collection("users").document(user.uid)
            docRef.getDocument { [weak self] (document, error) in
                DispatchQueue.main.async {
                    if let document = document, document.exists {
                        do {
                            let data = document.data()
                            let balance = data?["balance"] as? Double ?? 0
                            let balanceHistoryData = data?["balanceHistory"] as? [[String: Any]] ?? []
                            let balanceHistory = try balanceHistoryData.map { try JSONSerialization.data(withJSONObject: $0) }.map { try JSONDecoder().decode(BalanceRecord.self, from: $0) }
                            let firstName = data?["firstName"] as? String ?? ""
                            let lastName = data?["lastName"] as? String ?? ""
                            let fullName = "\(firstName) \(lastName)"
                            
                            // Assuming gameHistory is stored in a similar nested array of dictionaries as balanceHistory
                            let gameHistoryData = data?["gameHistory"] as? [[String: Any]] ?? []
                            let gameHistory = try gameHistoryData.map { try JSONSerialization.data(withJSONObject: $0) }.map { try JSONDecoder().decode(Game.self, from: $0) }

                            // Construct the UserModel for "Me"
                            self?.me = UserModel(name: fullName, balance: balance, balanceHistory: balanceHistory, gameHistory: gameHistory)

                            // If you want to include 'me' in the players array for leaderboard
                            if let me = self?.me {
                                self?.players.append(me)
                            }
                        } catch let error {
                            print("Error in decoding user data: \(error)")
                        }
                    } else {
                        print("User document does not exist")
                    }
                }
            }
        } else {
            print("No user is logged in")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            // Set the flag to show the login view
            showLoginView = true
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
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
        if let meIndex = players.firstIndex(where: { $0.id == me?.id }) {
            let mePlayer = players[meIndex]
            let newBalanceRecord = BalanceRecord(
                id: UUID().uuidString,
                date: Date(),
                amount: mePlayer.balance
            )
            me?.balanceHistory.append(newBalanceRecord) // Update "Me" user's balance history
            players[meIndex] = mePlayer
        }
        savePlayers()
        uploadBalanceHistoryToServer()
        
        print("Ending endGame function. Final state of players: \(players)")
    }

    func uploadBalanceHistoryToServer() {
        guard let me = me, let user = Auth.auth().currentUser else { return }
        let docRef = db.collection("users").document(user.uid)
        let balanceHistoryData = me.balanceHistory.map { record in
            [
                "id": record.id,
                "date": record.date,
                "amount": record.amount
            ]
        }
        docRef.updateData([
            "balanceHistory": balanceHistoryData
        ]) { error in
            if let error = error {
                print("Error updating balanceHistory: \(error)")
            }
        }
    }
    
    func saveGameHistory(player: UserModel, buyIn: Double, total: Double) {
        if let index = players.firstIndex(where: { $0.name == player.name }) {
            
            let game = Game(buyIn: buyIn,
                            total: total,
                            finishingBalance: player.balance + total,
                            date: Date(),
                            totalPool: players.reduce(0) { $0 + (Double($1.buyIn) ?? 0) }, // Calculate the total pool based on the buy-in of all players.
                            playersUIDs: players.map { $0.id.uuidString }) // Extracting the UUIDs of all players and converting them to strings.
            
            players[index].gameHistory.append(game)
            
            print("Game record saved for \(player.name) with buyIn: \(buyIn), total: \(total), on: \(game.date)")
            
            savePlayers() // Your method to save the updated players list.
        }
    }




    func updateGameHistory(game: Game) {
            guard let user = Auth.auth().currentUser else {
                print("No user logged in.")
                return
            }
            
            let docRef = db.collection("users").document(user.uid)
            // Convert Game object to a dictionary for Firestore
            let gameData: [String: Any] = [
                "buyIn": game.buyIn,
                "total": game.total,
                "finishingBalance": game.finishingBalance,
                "date": game.date
            ]
            
            docRef.updateData([
                "gameHistory": FieldValue.arrayUnion([gameData])
            ]) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error updating gameHistory: \(error)")
                    } else {
                        print("Successfully updated gameHistory.")
                    }
                }
            }
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

