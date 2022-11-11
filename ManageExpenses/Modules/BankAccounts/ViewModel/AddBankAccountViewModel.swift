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
    var service: BankServiceType  { get }
    init(service: BankServiceType)
    func addBankAccount()
}

class AddBankAccountViewModel: AddBankAccountViewModelType, ObservableObject {
    @Published var showAmtKeybd = false
    @Published var isBankAdded = false
    @Published var bank: SelectDataModel = .new
    var subscription = Set<AnyCancellable>()
    var service: BankServiceType
    required init(service: BankServiceType) {
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
