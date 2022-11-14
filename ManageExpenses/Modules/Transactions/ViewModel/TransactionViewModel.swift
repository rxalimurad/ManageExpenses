////
////  TransactionViewModel.swift
////  ManageExpenses
////
////  Created by Ali Murad on 18/10/2022.
////
//
import Foundation
import Combine
import UIKit

enum SortedBy: String, CaseIterable {
    case newest
    case oldest
    case lowest
    case highest
}

protocol TransactionViewModelType {
    var sortedBy: String { get }
    var filterBy: String { get }
    var transactions: [Transaction] { get }
    var pieChartPoints: [PieChartDataPoint] { get }
    var financialReportList: [FinanicalReportModel] { get}
    var dbHandler: ServiceHandlerType { get }
    var isLoading: Bool { get }
    var state: ServiceAPIState { get }
    init(dbHandler: ServiceHandlerType)
}



class TransactionViewModel: ObservableObject, TransactionViewModelType, UpdateTransaction {
    
    //MARK: - States for Views
    @Published var isDurationFilterSheetShowing = false
    @Published var isfilterSheetShowing = false
    @Published var isfinancialReportShowing = false
    @Published var customDateSeleced = false
    @Published var transDuration = FilterDuration.thisMonth.rawValue
    @Published var dateTo = Date()
    @Published var dateFrom = Date()
    @Published var selectedTrans: Transaction?
    var isLoading = false
    var subscriptions =  Set<AnyCancellable>()
    //MARK: - Protocol Implementation
    @Published var sortedBy: String = SortedBy.newest.rawValue
    @Published var filterBy: String = PlusMenuAction.all.rawValue
    @Published var transactions: [Transaction] = []
    var dbHandler: ServiceHandlerType
    @Published var state: ServiceAPIState = .na
    @Published var categoryData = Utilities.getCategories()
    var selectedCategoties: [String] = []
    @Published var pieChartPoints: [PieChartDataPoint] = []
    @Published var financialReportList: [FinanicalReportModel] = []
    @Published var selectedTab = "0"
    required init(dbHandler: ServiceHandlerType) {
        self.dbHandler = dbHandler
        self.fetchTransactions()
        self.observedCategory()
        self.observeTab()
    }
    
    //MARK: - Methods
    
    func refresh() {
        self.fetchTransactions()
    }
    
    func fetchTransactions() {
        self.transactions = []
        self.isLoading = true
        state = .inprogress
        self.dbHandler.getTransactions(
            duration: transDuration,
            sortBy: SortedBy(rawValue: sortedBy) ?? .newest,
            filterBy: (PlusMenuAction(rawValue: filterBy) ?? .all),
            selectedCat: selectedCategoties,
            fromDate: dateFrom,
            toDate: dateTo
        )
        .sink { error in
            self.state = .successful
            if case Subscribers.Completion.failure(_) = error {
                self.transactions = []
                self.financialReportList = []
                self.pieChartPoints = []
            }
        } receiveValue: { [weak self] transactions in
            guard let self = self else { return }
            self.isLoading = false
            self.transactions = transactions
            self.financialReportList = self.getFinanicalChartData(transactions: transactions, categoryData: self.categoryData, selectedTab: self.selectedTab)
            self.pieChartPoints = self.getFinacialChartPoints(transactions: transactions, categoryData: self.categoryData, selectedTab: self.selectedTab)
        }
        .store(in: &subscriptions)
        
    }
    
    private func observeTab() {
        $selectedTab
            .sink {[weak self] newTab in
                guard let self = self else { return }
                self.financialReportList = self.getFinanicalChartData(transactions: self.transactions, categoryData: self.categoryData, selectedTab: newTab)
                self.pieChartPoints = self.getFinacialChartPoints(transactions: self.transactions, categoryData: self.categoryData, selectedTab: newTab)
            }
            .store(in: &subscriptions)
    }
    private func observedCategory() {
        $categoryData
            .sink { [weak self]  selectDataList in
                self?.selectedCategoties = selectDataList.filter({ $0.isSelected }).map({$0.desc})
            }
            .store(in: &subscriptions)
    }
    
    internal func resetFilters() {
        sortedBy = SortedBy.newest.rawValue
        filterBy = PlusMenuAction.all.rawValue
        selectedCategoties = []
    }
    internal func resetDurationFilters() {
        transDuration = FilterDuration.thisMonth.rawValue
        dateTo = Date()
        dateFrom = Date()
    }
    
    //MARK: - Methods for Financial Chart
    private func getFinacialChartPoints(transactions: [Transaction],categoryData: [SelectDataModel], selectedTab: String) -> [PieChartDataPoint] {
        let list = getFinanicalChartData(transactions:transactions, categoryData: categoryData, selectedTab: selectedTab)
        var points = [PieChartDataPoint]()
        for data in list {
            points.append(PieChartDataPoint(value: data.amount, description: "", colour: data.category.color))
        }
        return points
      
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
    
    private func getFinanicalChartData(transactions: [Transaction], categoryData: [SelectDataModel], selectedTab: String) -> [FinanicalReportModel] {
        var total = 1.0
        if selectedTab == "0" {
            total = getTotalExpense(trans: transactions)
        } else {
            total = getTotalIncome(trans: transactions)
        }
        
        var reportModel = categoryData.map({
            return FinanicalReportModel(category: $0, amount: 0, total: total)
        })
        for i in 0 ..< transactions.count {
            if selectedTab == "0" {
                if transactions[i].amount < 0 {
                    for j in 0 ..< reportModel.count {
                        if reportModel[j].category.desc == transactions[i].name {
                            reportModel[j].amount += transactions[i].amount
                            break
                        }
                    }
                }
            } else {
                if transactions[i].amount > 0 {
                    for j in 0 ..< reportModel.count {
                        if reportModel[j].category.desc == transactions[i].name {
                            reportModel[j].amount += transactions[i].amount
                            break
                        }
                    }
                }
            }
        }
        return reportModel.sorted(by: {abs($0.amount) > abs($1.amount) }).filter({ $0.amount != 0.0})
    }
    
    private func getTotalIncome(trans: [Transaction]) -> Double {
        var total = 0.0
        
        for t in trans {
            if t.amount > 0 {
            total += abs(t.amount)
            }
        }
        return total
    }
    private func getTotalExpense(trans: [Transaction]) -> Double {
        var total = 0.0
        
        for t in trans {
            if t.amount < 0 {
            total += abs(t.amount)
            }
        }
        return total
    }
    
    
}
