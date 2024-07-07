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
        isToShowAddBank =  DataCache.shared.banks.isEmpty
        self.fetchTransactions(filter: currentFilter)
    }
    
    func deleteTransaction(transaction: Transaction, completion: @escaping((Bool) -> Void)) {
        
        dbHandler.deleteTransaction(transaction: transaction)
            .sink { error in
                switch error {
                case .failure(_):
                    completion(false)
                default: break
                
                }
            } receiveValue: { _ in
                completion(true)
            }
            .store(in: &subscriptions)
    }
    private func fetchTransactions(filter: String? = nil) {
        if DataCache.shared.banks.isEmpty {
            return 
        }
        self.transactions = []
        state = .inprogress
        isLoading = true
        let transDur = TransactionDuration(rawValue: filter ?? currentFilter) ?? TransactionDuration.thisMonth
        self.dbHandler.getTransactions(duration: getTransactionFilter(duration: transDur), sortBy: .newest, filterBy: .all, selectedCat: [], fromDate: Date(), toDate: Date()) {error, trans in
            if let _ = error {
                self.transactions = []
                self.lineChartData = LineChartData(dataSets: LineDataSet(dataPoints: []))
                self.income = UserDefaults.standard.currency + "0"
                self.expense = UserDefaults.standard.currency + "0"
                self.totalAmount = UserDefaults.standard.currency + "0"
                self.isLoading = false
            } else {
                if filter == self.currentFilter {
                    self.isLoading = false
                    self.transactions = self.proccessTransactions(trans ?? [])
                    let amounts = (trans ?? []).map({ $0.amount })
                    self.income = Utilities.getFormattedAmount(amount: amounts.filter({ $0 > 0}).reduce(0, +))
                    self.expense = Utilities.getFormattedAmount(amount: amounts.filter({ $0 < 0}).reduce(0, +))
                    var bankBalance: Double = 0
                    for bank in DataCache.shared.banks {
                        bankBalance += Double(bank.balance ?? "0")!
                    }
                    
                    self.totalAmount = UserDefaults.standard.currency + " \(bankBalance)"
                    self.lineChartData = self.getChartData(transaction: self.transactions, filter: filter)
                    self.state = .successful
                    
                    if filter == TransactionDuration.thisMonth.rawValue && DataCache.shared.catSpendingDict.isEmpty {
                        for tran in trans ?? [] {
                            if tran.amount < 0 {
                                if DataCache.shared.catSpendingDict[tran.category.lowercased()] == nil {
                                    DataCache.shared.catSpendingDict[tran.category.lowercased()] = abs(tran.amount)
                                } else {
                                    DataCache.shared.catSpendingDict[tran.category.lowercased()]! += abs(tran.amount)
                                }
                            }
                        }
                    }
                    
                }
                
                
                
            }
            
            
            
        }
        
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
    
    // MARK: - Helper
    
    func getTransactionFilter(duration: TransactionDuration) -> String {
        switch duration {
        case .thisDay:
            return FilterDuration.today.rawValue
        case .thisMonth:
            return FilterDuration.thisMonth.rawValue
        case .thisWeek:
            return FilterDuration.thisWeek.rawValue
        case .thisYear:
            return FilterDuration.thisYear.rawValue
        case .customRange:
            return FilterDuration.thisMonth.rawValue
        }
    }
    
    private func proccessTransactions(_ transactions: [Transaction]) -> [DatedTransactions] {
        var recentTransactionsKeys: [String] = []
        let sortedTrans = transactions.sorted(by: { $0.date > $1.date })
        var dict = [String: [Transaction]]()
        for trans in sortedTrans {
            if dict[trans.date.dateToShow] == nil {
                dict[trans.date.dateToShow] = [trans]
                recentTransactionsKeys.append(trans.date.dateToShow)
            } else {
                dict[trans.date.dateToShow] = dict[trans.date.dateToShow]! + [trans]
            }
        }
        var list = [DatedTransactions]()
        for key in recentTransactionsKeys {
            let obj = dict[key]!
            list.append(DatedTransactions(date: key, transactions: obj))
        }
        
        
        return list
    }
    
}
