//
//  LoginViewModel.swift
//  ManageExpenses
//
//  Created by murad on 01/11/2022.
//


import Foundation
import Combine
import SwiftUI
import Firebase
import GoogleSignIn

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
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
          GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
              authenticateUser(for: user, with: error)
          }
        } else {
          guard let clientID = FirebaseApp.app()?.options.clientID else { return }
          let configuration = GIDConfiguration(clientID: clientID)
          guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
          guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
          GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
            authenticateUser(for: user, with: error)
          }
        }
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
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        self.state = .inprogress
      if let error = error {
          self.state = .failed(error: NetworkingError(error.localizedDescription))
        return
      }
      
      guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
      
      // 3
      Auth.auth().signIn(with: credential) { [weak self] (data, error) in
          guard let self = self else { return }
        if let error = error {
            self.state = .failed(error: NetworkingError(error.localizedDescription))
          print(error.localizedDescription)
        } else {
          self.state = .successful
            self.userDetails.name = user?.profile?.name ?? "Unknown"
            self.userDetails.email = user?.profile?.email ?? "Unknown"
            self.fetchBanks()
        }
      }
    }
    
}
