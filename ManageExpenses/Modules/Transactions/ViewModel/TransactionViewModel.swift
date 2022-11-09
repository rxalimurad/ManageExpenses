////
////  TransactionViewModel.swift
////  ManageExpenses
////
////  Created by Ali Murad on 18/10/2022.
////
//
import Foundation
import Combine

enum SortedBy {
    case newest
    case oldest
    case lowest
    case highest
}

enum TransFilters {
    case thisDay
    case thisWeek
    case thisMonth
    case thisYear
    case customRange
}

protocol TransactionViewModelType {
    var currentFilter: TransFilters { get }
    var sortedBy: SortedBy { get }
    var transactions: [Transaction] { get }
    var dbHandler: ServiceHandlerType { get }
    var state: ServiceAPIState { get }
    init(dbHandler: ServiceHandlerType)
}



class TransactionViewModel: ObservableObject, TransactionViewModelType {
    //MARK: - States for Views
    @Published var isDurationFilterSheetShowing = false
    @Published var isfilterSheetShowing = false
    @Published var isfinancialReportShowing = false
    @Published var customDateSeleced = false
    @Published var dateTo = Date()
    @Published var dateFrom = Date()
    @Published var selectedTrans: Transaction?
    var subscriptions =  Set<AnyCancellable>()
    //MARK: - Protocol Implementation
    @Published var currentFilter: TransFilters = .thisMonth
    @Published var sortedBy: SortedBy = .newest
    @Published var transactions: [Transaction] = []
    var dbHandler: ServiceHandlerType
    @Published var state: ServiceAPIState = .na
    
    required init(dbHandler: ServiceHandlerType) {
        self.dbHandler = dbHandler
        self.fetchTransactions(filter: currentFilter, sortedBy: sortedBy)
        self.observedFilter()
    }
    
    //MARK: - Methods
    
    func observedFilter() {
        $currentFilter
            .sink { filter in
                self.fetchTransactions(filter: filter, sortedBy: self.sortedBy)
            }
            .store(in: &subscriptions)
    }
    func refresh() {
        self.fetchTransactions(filter: currentFilter, sortedBy: sortedBy)
    }
    
    private func fetchTransactions(filter: TransFilters, sortedBy: SortedBy) {
        self.transactions = []
        state = .inprogress
        self.dbHandler.getTransactions(duration: filter, sortBy: sortedBy)
            .sink { error in
                self.state = .successful
                if case Subscribers.Completion.failure() = error {
                    self.transactions = []
                }
            } receiveValue: { [weal self] transactions in
                guard let self = self else { return }
                if filter == self.currentFilter {
                    self.transactions = transactions
                    self.state = .successful
                }
            }
            .store(in: &subscriptions)

    }
    
    
    
    
}
