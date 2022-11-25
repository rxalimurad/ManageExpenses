//
//  SplashViewModel.swift
//  ManageExpenses
//
//  Created by murad on 12/11/2022.
//

import Foundation
import Combine

class SplashViewModel: ObservableObject {
    var sub = Set<AnyCancellable>()
    var service: ServiceHandlerType
    init(service: ServiceHandlerType) {
        self.service = service
    }
    
    func fetchBanks(completion: @escaping((_ success: Bool) -> Void)) {
        if UserDefaults.standard.currentUser != nil {
        service.getBanksList()
            .sink { error in
                completion(false)
            } receiveValue: { banks in
                DataCache.shared.banks = banks
                completion(true)
            }
            .store(in: &sub)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(true)
            }
        }
    }
    func fetchBudgets(completion: @escaping((_ success: Bool) -> Void)) {
        if UserDefaults.standard.currentUser != nil {
        service.fetchBudgetList()
            .sink { error in
                completion(false)
            } receiveValue: { budget in
                DataCache.shared.budget = budget
                completion(true)
            }
            .store(in: &sub)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                completion(true)
            }
        }
    }
    
}
