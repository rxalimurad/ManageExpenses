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
    @Published var transaction: [Transaction] = []
    var service: ServiceHandlerType
    
    init(bankId: String, service: ServiceHandlerType) {
        self.service = service
        service.getTransactions(bankId: bankId)
            .sink { error in
                print(error)
            } receiveValue: { trans in
                self.transaction = trans
            }
            .store(in: &sub)

    }
}
