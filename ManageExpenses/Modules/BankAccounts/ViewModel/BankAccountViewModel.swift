//
//  BankAccountViewModel.swift
//  ManageExpenses
//
//  Created by Ali Murad on 11/11/2022.
//

import Foundation
import Combine
protocol BankAccountViewModelType {
    var banks: [SelectDataModel] { get }
    var service: ServiceHandlerType  { get }
    init(service: ServiceHandlerType)
    func fetchBanks()
}

class BankAccountViewModel: BankAccountViewModelType, ObservableObject {
    @Published var banks: [SelectDataModel] = []
    
    var service: ServiceHandlerType
    
    var subscription = Set<AnyCancellable>()
    
    
    required init(service: ServiceHandlerType) {
        self.service = service
        fetchBanks()
    }
    
    func fetchBanks() {
        service.getBanksList()
            .sink { error in
                print(error)
            } receiveValue: { banks in
                self.banks = banks
            }
            .store(in: &subscription)
}
    
    
}
