//
//  LoginViewModel.swift
//  ManageExpenses
//
//  Created by murad on 01/11/2022.
//


import Foundation
import Combine
import SwiftUI
//import Firebase

protocol LoginViewModelType {
    var service: LoginServiceType { get }
    var state: ServiceAPIState { get }
    var userDetails: UserDetailsModel { get }
    init(service: LoginServiceType)
    func signin()
    
}

class LoginViewModel: ObservableObject, LoginViewModelType {
    var sessionService: SessionService?
    //MARK: - Variables for Input Validation
    @Published var isValidEmail = false
    @Published var isValidPassword = false
    @Published var showIntro  = true
    
    //MARK: - Protocol Implementation
    var service: LoginServiceType
    
    @Published  var state: ServiceAPIState = .na
    @Published  var userDetails: UserDetailsModel = .new
    
    var subscriptions = Set<AnyCancellable>()
    
    required init(service: LoginServiceType) {
        self.service = service
    }
    
    func signin() {
        self.state = .inprogress
        UIApplication.shared.endEditing()
        service.login(with: userDetails)
            .sink {[weak self] res in
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
            } receiveValue: {[weak self] name in
                self?.userDetails.name = name
                guard let self = self else { return }
                self.fetchBanks()
            }
            .store(in: &subscriptions)
    }
    
    func googleSignin() {
       
      }
  
    func fetchBanks() {
        service.fetchBanks()
            .sink {[weak self] res in
            switch res {
            case .failure(let error):
                self?.state = .failed(error: error)
            default: break
            }
        } receiveValue: {[weak self] in
            guard let self = self else { return }
            self.state = .successful
            self.sessionService?.login(with: self.userDetails)
        }
        .store(in: &subscriptions)

    }
    
    func setupSession(session: SessionService) {
        self.sessionService = session
    }
    
    
    
}
