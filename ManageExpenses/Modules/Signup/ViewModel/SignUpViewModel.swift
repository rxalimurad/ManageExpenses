//
//  SignUpViewModel.swift
//  ManageExpenses
//
//  Created by Ali Murad on 02/11/2022.
//

import Foundation
import Combine

enum SignupState {
    case successful
    case inprogress
    case failed(error: Error)
    case na
}

protocol SignUpViewModelType {
    var service: SignupServiceType { get }
    var state: SignupState { get }
    var userDetails: UserDetailsModel { get }
    init(service: SignupServiceType)
    func createUser()
    
} 


class SignUpViewModel: ObservableObject, SignUpViewModelType {
    //MARK: - Variables for Input Validations
    @Published var isTermsAccepted = false
    @Published var isTermsShowing = false
    @Published var isValidEmail = false
    @Published var isValidPassword = false
    @Published var isValidName = false
    @Published var state: SignupState = .na
    //MARK: - Protocol Implementation
    var service: SignupServiceType
    
    @Published var userDetails: UserDetailsModel = UserDetailsModel.new
    var subscriptions = Set<AnyCancellable>()
    
    required init(service: SignupServiceType) {
        self.service = service
    }
    
    func createUser() {
        self.state = .inprogress
        service.signup(with: userDetails)
            .sink {[weak self] res in
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
            } receiveValue: {[weak self] in
                self?.state = .successful
            }
            .store(in: &subscriptions)
    }
    
    
}

