//
//  ChartView.swift
//  LossTracker
//
//  Created by Henry Webb on 12/19/23.
//

import SwiftUI
import Charts

struct ChartView: View {
    var balanceHistory: [GameViewModel.BalanceRecord]

    @State private var selectedBalance: GameViewModel.BalanceRecord?

    var body: some View {
        Chart(balanceHistory, id: \.id) { record in
            LineMark(
                x: .value("Date", record.date),
                y: .value("Balance", record.amount)
            )
            PointMark(
                x: .value("Date", record.date),
                y: .value("Balance", record.amount)
            )
            .foregroundStyle(by: .value("Balance", record.amount))
        }
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(DragGesture().onChanged { value in
                        let location = value.location
                        let x = location.x - geometry[proxy.plotAreaFrame].origin.x
                        if let date: Date = proxy.value(atX: x, as: Date.self) {
                            if let closest = balanceHistory.min(by: { abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date)) }) {
                                selectedBalance = closest
                            }
                        }
                    })
            }
        }
        .frame(height: 300)
        .padding()
    }
}


