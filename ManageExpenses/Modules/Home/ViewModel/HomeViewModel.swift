//
//  HomeViewModel.swift
//  ManageExpenses
//
//  Created by murad on 18/10/2022.
//

import Foundation
import Combine
import SwiftUI


protocol HomeViewModelType {
    var currentFilter: Int { get }
    var transactions: [DatedTransactions] { get }
    var lineChartData: LineChartData { get }
    var dbHandler: ServiceHandlerType { get }
    var state: ServiceAPIState { get }
    init(dbHandler: ServiceHandlerType)
    func getAccountBalance() -> String
    func getIncome() -> String
    func getExpense() -> String
    
}

class HomeViewModel: ObservableObject, HomeViewModelType {
    @Published internal var currentFilter: Int = 0
    
    var subscriptions =  Set<AnyCancellable>()
    @Published var transactions: [DatedTransactions] = []
    @Published var lineChartData: LineChartData = LineChartData(dataSets: LineDataSet(dataPoints: []))
    var dbHandler: ServiceHandlerType
    @Published var state: ServiceAPIState = .na
    required init(dbHandler: ServiceHandlerType) {
        self.dbHandler = dbHandler
        self.fetchTransactions()
        observedFilter()
    }
    
    func getAccountBalance() -> String {
        return dbHandler.getTotalBalance()
    }
    func getIncome() -> String {
        return dbHandler.getIncome()
    }
    func getExpense() -> String {
        return dbHandler.getExpense()
    }
    
    func observedFilter() {
        $currentFilter
            .sink { filter in
                self.fetchTransactions(filter: filter)
            }
            .store(in: &subscriptions)
    }
    
    func fetchTransactions(filter: Int? = nil) {
        
        state = .inprogress
        self.dbHandler.getTransactions(for: TransactionDuration(rawValue: filter ?? currentFilter) ?? TransactionDuration.thisMonth)
            .sink(receiveCompletion: { error in
                self.state = .successful
                self.transactions = []
                self.lineChartData = LineChartData(dataSets: LineDataSet(dataPoints: []))
            }, receiveValue: {[weak self] transactions in
                guard let self = self else { return }
                self.transactions = transactions
                self.lineChartData = self.getChartData(transaction: transactions)
                self.state = .successful
            })
            .store(in: &subscriptions)
    }
    
    private func getChartData(transaction: [DatedTransactions]) -> LineChartData {
        let trans = transaction.flatMap { trans in
            return trans.transactions
        }
        var dataPoints = [LineChartDataPoint]()
        
        for t in trans.sorted(by: { $0.date < $1.date}) {
            dataPoints.append( LineChartDataPoint(value: t.amount, xAxisLabel: "1", description: ""))
        }
        let data = LineDataSet(
            dataPoints: dataPoints,
            pointStyle: PointStyle(pointSize: 12, borderColour:.yellow, fillColour: .red, lineWidth: 10, pointType: .filled, pointShape: .circle),
            style: LineStyle(lineColour: ColourStyle(colour: CustomColor.primaryColor), lineType: .curvedLine, strokeStyle: Stroke(lineWidth: 8)))
        
        
        let chartStyle = LineChartStyle(
            markerType: LineMarkerType.full(attachment: MarkerAttachment.point,
                                            colour: CustomColor.primaryColor),
            xAxisLabelColour: CustomColor.primaryColor,
            xAxisBorderColour: CustomColor.primaryColor,
            yAxisLabelPosition: .leading,
            yAxisLabelColour: CustomColor.primaryColor,
            yAxisNumberOfLabels: 5,
            yAxisLabelType: .numeric,
            yAxisTitle: "",
            yAxisTitleColour: .black)
        return LineChartData(dataSets: data, chartStyle: chartStyle)
        
    }

}
