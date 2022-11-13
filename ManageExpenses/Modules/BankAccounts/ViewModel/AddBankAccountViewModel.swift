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
    func addBankAccount()
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
    
    func addBankAccount() {
        service.saveBank(bank: self.bank)
            .sink { err in
                print(err)
            } receiveValue: {_  in
                
            }
            .store(in: &subscription)
        
    }
    
    
}
