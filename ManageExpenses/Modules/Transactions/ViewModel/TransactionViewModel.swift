////
////  TransactionViewModel.swift
////  ManageExpenses
////
////  Created by Ali Murad on 18/10/2022.
////
//
import Foundation
import Combine

enum SortedBy: String, CaseIterable {
    case newest
    case oldest
    case lowest
    case highest
}

protocol TransactionViewModelType {
    var currentFilter: TransactionDuration { get }
    var sortedBy: String { get }
    var filterBy: String { get }
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
    @Published var currentFilter: TransactionDuration = .thisMonth
    @Published var sortedBy: String = SortedBy.newest.rawValue
    @Published var filterBy: String = PlusMenuAction.all.rawValue
    @Published var transactions: [Transaction] = []
    var dbHandler: ServiceHandlerType
    @Published var state: ServiceAPIState = .na
    
    required init(dbHandler: ServiceHandlerType) {
        self.dbHandler = dbHandler
        self.fetchTransactions()
    }
    
    //MARK: - Methods
    
    func refresh() {
        self.fetchTransactions()
    }
    
     func fetchTransactions() {
        self.transactions = []
        state = .inprogress
         self.dbHandler.getTransactions(
            duration: currentFilter,
            sortBy: SortedBy(rawValue: sortedBy) ?? .newest,
            filterBy: PlusMenuAction(rawValue: filterBy) ?? .all)
            .sink { error in
                self.state = .successful
              if case Subscribers.Completion.failure(_) = error {
                    self.transactions = []
                }
            } receiveValue: { [weak self] transactions in
                guard let self = self else { return }
                    self.transactions = transactions
                    self.state = .successful
            }
            .store(in: &subscriptions)

    }
    
    
    
    
}
