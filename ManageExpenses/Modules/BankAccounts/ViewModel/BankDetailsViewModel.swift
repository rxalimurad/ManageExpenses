//
//  BankDetailsViewModel.swift
//  ManageExpenses
//
//  Created by Ali Murad on 23/11/2022.
//

import Foundation
import Combine

class BankDetailsViewModel: ObservableObject {
    var sub = Set<AnyCancellable>()
    var bankId: String
    @Published var isLoading = false
    @Published var transaction: [Transaction] = []
    var service: ServiceHandlerType
    
    init(bankId: String, service: ServiceHandlerType) {
        self.service = service
        self.bankId = bankId
        isLoading = true
        service.getTransactions(bankId: bankId)
            .sink { error in
                print(error)
                self.isLoading = false
            } receiveValue: { trans in
                self.transaction = trans
                self.isLoading = false
            }
            .store(in: &sub)

    }
    
    func deleteBankAccount() {
        self.service.deleteBank(bank: bankId)
            .receive(on: RunLoop.main)
            .sink { error in
                print(error)
            } receiveValue: { _ in
                
            }
            .store(in: &sub)

    }
}
