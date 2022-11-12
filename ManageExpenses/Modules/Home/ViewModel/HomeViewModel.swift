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
    var currentFilter: String { get }
    var totalAmount: String { get }
    var expense: String { get }
    var income: String { get }
    var transactions: [DatedTransactions] { get }
    var lineChartData: LineChartData { get }
    var dbHandler: ServiceHandlerType { get }
    var state: ServiceAPIState { get }
    init(dbHandler: ServiceHandlerType)
}

class HomeViewModel: ObservableObject, HomeViewModelType, UpdateTransaction {
    @Published var totalAmount: String = "0"
    
    @Published internal var expense: String = UserDefaults.standard.currency + "0"
    @Published internal var income: String = UserDefaults.standard.currency + "0"
    
    @Published internal var currentFilter: String = TransactionDuration.thisMonth.rawValue
    @Published internal var isLoading: Bool = true
    @Published internal var options = ["Day","Week","Month", "Year"]
    @Published internal var graphXAxis = ["Hours (24 hour formate)","","", ""]
    var subscriptions =  Set<AnyCancellable>()
    @Published var isToShowAddBank =  DataCache.shared.banks.isEmpty
    @Published var transactions: [DatedTransactions] = []
    @Published var lineChartData: LineChartData = LineChartData(dataSets: LineDataSet(dataPoints: []))
    var dbHandler: ServiceHandlerType
    @Published var state: ServiceAPIState = .na
    required init(dbHandler: ServiceHandlerType) {
        self.dbHandler = dbHandler
        self.fetchTransactions()
        observedFilter()
    }
    
    func observedFilter() {
        $currentFilter
            .sink {[weak self] filter in
                guard let self = self else { return }
                self.fetchTransactions(filter: filter)
            }
            .store(in: &subscriptions)
    }
    func refresh() {
        self.fetchTransactions(filter: currentFilter)
    }
    
    func deleteTransaction(id: String, completion: @escaping((Bool) -> Void)) {
        dbHandler.delteTransaction(id: id)
            .sink { _ in
                completion(false)
            } receiveValue: { _ in
                completion(true)
            }
            .store(in: &subscriptions)
    }
    private func fetchTransactions(filter: String? = nil) {
        self.transactions = []
        state = .inprogress
        isLoading = true
        self.dbHandler.getTransactions(for: TransactionDuration(rawValue: filter ?? currentFilter) ?? TransactionDuration.thisMonth)
            .sink(receiveCompletion: { error in
                self.state = .successful
                if case Subscribers.Completion.failure(_) = error {
                    self.transactions = []
                    self.lineChartData = LineChartData(dataSets: LineDataSet(dataPoints: []))
                    self.income = UserDefaults.standard.currency + "0"
                    self.expense = UserDefaults.standard.currency + "0"
                    self.totalAmount = UserDefaults.standard.currency + "0"
                    self.isLoading = false
                }
            }, receiveValue: {[weak self] (transactions, income, expense) in
                guard let self = self else { return }
                if filter == self.currentFilter {
                        self.isLoading = false
                        self.transactions = transactions
                        self.income = income
                        self.expense = expense
                    var bankBalance: Double = 0
                    for bank in DataCache.shared.banks {
                        bankBalance += Double(bank.balance ?? "0")!
                    }
                    
                        self.totalAmount = UserDefaults.standard.currency + " \(bankBalance)"
                        self.lineChartData = self.getChartData(transaction: transactions, filter: filter)
                        self.state = .successful
                 
                }
            })
            .store(in: &subscriptions)
    }
    
    private func getDataPoint(trans: [Transaction], filter: String?) -> [LineChartDataPoint] {
        var dataPoints = [LineChartDataPoint]()
        let transaction = trans.filter({ $0.amount < 0})
        if let filter = filter, let filterType = TransactionDuration(rawValue: filter) {
            switch filterType {
            case .thisDay:
                var days = [Int: Double]()
                for t in transaction {
                    if days[t.date.hour24] == nil {
                        days[t.date.hour24] = t.amount
                    } else {
                        days[t.date.hour24]! += t.amount
                    }
                }
                for (day, amount) in days {
                    dataPoints.append(LineChartDataPoint(value: amount, xAxisLabel: "\(day)", description: ""))
                }
                return dataPoints.sorted(by: { Int($0.xAxisLabel!)! < Int($1.xAxisLabel!)!})
                
            case .thisWeek:
                let thisWeek = Calendar.current.date(byAdding: .day, value: -7, to: Date())?.dateToShow ?? ""
                let thisDay = Date().dateToShow
                graphXAxis[1] = "\(thisWeek) to \(thisDay)"
                var days = [Int: Double]()
                for t in transaction {
                    if days[t.date.getDate()] == nil {
                        days[t.date.getDate()] = t.amount
                    } else {
                        days[t.date.getDate()]! += t.amount
                    }
                }
                for (day, amount) in days {
                    let dayStr = String(Array("\(day)")[6 ... 7])
                    dataPoints.append(LineChartDataPoint(value: amount, xAxisLabel: "\(dayStr)", description: ""))
                }
                return dataPoints.sorted(by: { $0.xAxisLabel! < $1.xAxisLabel! })
                
            case .thisMonth:
                graphXAxis[2] = "Days of \(Date().month)"
                var days = [Int: Double]()
                for t in transaction {
                    if days[t.date.get(.day)] == nil {
                        days[t.date.get(.day)] = t.amount
                    } else {
                        days[t.date.get(.day)]! += t.amount
                    }
                }
                var i = 0
                for (day, amount) in days {
                    var xLabel = "\(day)"
                    if days.count > 15 {
                        if i % 2 == 1 {
                            xLabel = "\(day)"
                        } else {
                            xLabel = ""
                        }
                    }
                    
                    dataPoints.append(LineChartDataPoint(value: amount, xAxisLabel: xLabel, description: "\(day)"))
                    i += 1
                }

                return dataPoints.sorted(by: { Int($0.description!)! < Int($1.description!)!})
                
            case .thisYear:
                graphXAxis[3] = "Months of \(Date().year)"
                var days = [Int: Double]()
                for t in transaction {
                    if days[t.date.get(.month)] == nil {
                        days[t.date.get(.month)] = t.amount
                    } else {
                        days[t.date.get(.month)]! += t.amount
                    }
                }
                for (day, amount) in days {
                    dataPoints.append(LineChartDataPoint(value: amount, xAxisLabel: "\(day)", description: ""))
                }
                return dataPoints.sorted(by: { Int($0.xAxisLabel!)! < Int($1.xAxisLabel!)!})
            default:
                return []
            }
             
        }
        return dataPoints
    }
    
    private func getChartData(transaction: [DatedTransactions], filter: String?) -> LineChartData {
        let trans = transaction.flatMap { trans in
            return trans.transactions
        }
        let dataPoints = getDataPoint(trans: trans, filter: filter)
        let data = LineDataSet(
            dataPoints: dataPoints,
            pointStyle: PointStyle(pointSize: 10, borderColour:.yellow, fillColour: .red, lineWidth: 8, pointType: .filled, pointShape: .circle),
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
