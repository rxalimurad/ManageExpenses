//
//  AddBankAccountViewModel.swift
//  ManageExpenses
//
//  Created by Ali Murad on 11/11/2022.
//

import Foundation
import Combine

protocol AddBankAccountViewModelType {
    var bank: SelectDataModel { get }
    var service: ServiceHandlerType  { get }
    init(service: ServiceHandlerType)
    func addBankAccount(complete: @escaping ((Bool) -> Void))
}

class AddBankAccountViewModel: AddBankAccountViewModelType, ObservableObject {
    @Published var showAmtKeybd = false
    @Published var isBankAdded = false
    @Published var bank: SelectDataModel = .new
    var subscription = Set<AnyCancellable>()
    var service: ServiceHandlerType
    required init(service: ServiceHandlerType) {
        self.service = service
    }
    
    func addBankAccount(complete: @escaping ((Bool) -> Void)) {
        service.saveBank(bank: self.bank)
            .sink { error in
                if case Subscribers.Completion.failure(_) = error {
                    complete(false)
                }
            } receiveValue: {_  in
                complete(true)
            }
            .store(in: &subscription)
        
    }
    
    
}
