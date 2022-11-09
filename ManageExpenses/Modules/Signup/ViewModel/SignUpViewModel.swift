//
//  SignUpViewModel.swift
//  ManageExpenses
//
//  Created by Ali Murad on 02/11/2022.
//

import Foundation
import Combine
import UIKit

protocol SignUpViewModelType {
    var service: SignupServiceType { get }
    var state: ServiceAPIState { get }
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
    @Published var moveNext = false
    @Published var state: ServiceAPIState = .na
    //MARK: - Protocol Implementation
    var service: SignupServiceType
    
    @Published var userDetails: UserDetailsModel = UserDetailsModel.new
    var subscriptions = Set<AnyCancellable>()
    
    required init(service: SignupServiceType) {
        self.service = service
    }
    
    func createUser() {
        self.state = .inprogress
        UIApplication.shared.endEditing()
        service.signup(with: userDetails)
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


