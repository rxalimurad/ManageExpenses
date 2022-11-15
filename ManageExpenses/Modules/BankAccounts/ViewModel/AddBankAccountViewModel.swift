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
    @Published var state: ServiceAPIState = .na
    var subscription = Set<AnyCancellable>()
    var service: ServiceHandlerType
    required init(service: ServiceHandlerType) {
        self.service = service
    }
    
    func addBankAccount(complete: @escaping ((Bool) -> Void)) {
        state = .inprogress
        service.saveBank(bank: self.bank)
            .sink { [weak self] error in
                if case Subscribers.Completion.failure(_) = error {
                    self?.state = .failed(error: NetworkingError("Some error occured.\nPlease try again."))
                    complete(false)
                }
            } receiveValue: {[weak self] _  in
                self?.state = .successful
                complete(true)
            }
            .store(in: &subscription)
        
    }
    
    
}
