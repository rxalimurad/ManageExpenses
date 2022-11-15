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
    var subscription = Set<AnyCancellable>()
    var service: ServiceHandlerType
    required init(service: ServiceHandlerType) {
        self.service = service
        fetchBanks()
    }
    
    func fetchBanks() {
        DataCache.shared.$banks
            .sink { banks in
                self.banks = banks
            }
            .store(in: &subscription)
    }
    
    
}
