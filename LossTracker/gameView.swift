//
//  gameView.swift
//  LossTracker
//
//  Created by Henry Webb on 7/10/23.
//

import SwiftUI

struct gameView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @State private var showingShameView = false
    @State private var showingEndGame = false
    @State private var showingFinishedView = false
    @Binding var showingGameView: Bool
    @EnvironmentObject var time_manage: GameViewModel.TimerClass

    var body: some View {
        VStack {
            ZStack {
                // Timer
                if (time_manage.mins_passed * 60 + time_manage.seconds_passed) < 3600 {
                    Text("\(String(format: "%02i:%02i:%02i", time_manage.mins_passed, time_manage.seconds_passed, time_manage.fractional_second))")
                        .font(.largeTitle)
                } else { // If over an hour
                    Text("\(String(format: "%02i:%02i:%02i", time_manage.mins_passed/60, time_manage.mins_passed%60, time_manage.seconds_passed))")
                        .font(.largeTitle)
                }
            }
            .padding(.top)

            // Custom list of players with their buy-in amounts
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(gameViewModel.players.filter { $0.isSelected }, id: \.self) { player in
                        HStack {
                            Text(player.name)
                                .font(.title)
                                .foregroundColor(.white)
                            Spacer()
                            Text("$\(Double(player.buyIn) ?? 0.0, specifier: "%.2f")")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        Divider()
                    }
                }
            }


            Spacer()

            Button(action: {
                showingShameView = true
            }) {
                Text("Buy Back In")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom)
            .sheet(isPresented: $showingShameView) {
                ShameView()
                    .environmentObject(gameViewModel)
            }

            Button(action: {
                showingEndGame = true
                self.time_manage.end()
            }) {
                Text("End Game")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom)
            .sheet(isPresented: $showingEndGame) {
                endGame(showingGameView: self.$showingGameView, showingFinishedView: self.$showingFinishedView)
                    .environmentObject(gameViewModel)
            }
        }
        .onAppear() {
            self.time_manage.start()
        }
    }
}
