//
//  ForgotPasswordViewModel.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import Foundation
import Combine
import UIKit

protocol ForgotPasswordViewModelType {
    var service: ForgotPasswordServiceType { get }
    var email: String { get }
    var state: ServiceAPIState { get }
    init(service: ForgotPasswordServiceType)
    func resetUser()
    
}


class ForgotPasswordViewModel: ObservableObject, ForgotPasswordViewModelType {
    //MARK: - Variables for Input Validations
    @Published var email: String = ""
    @Published var isValidEmail = false
    @Published var moveNext = false
    @Published var state: ServiceAPIState = .na
    //MARK: - Protocol Implementation
    var service: ForgotPasswordServiceType
    var subscriptions = Set<AnyCancellable>()
    
    required init(service: ForgotPasswordServiceType) {
        self.service = service
    }
    
    func resetUser() {
        self.state = .inprogress
        UIApplication.shared.endEditing()
        service.reset(email: email)
            .sink {[weak self] res in
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
            } receiveValue: {[weak self] in
                self?.state = .successful
                self?.moveNext = true
            }
            .store(in: &subscriptions)
    }
    
    
}


