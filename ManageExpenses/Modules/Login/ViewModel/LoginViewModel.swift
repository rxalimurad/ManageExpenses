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
import AuthenticationServices

protocol LoginViewModelType {
    var service: LoginServiceType { get }
    var state: ServiceAPIState { get }
    var userDetails: UserDetailsModel { get }
    init(service: LoginServiceType)
    func signin()
    func googleSignin()
    func appleSignin()
}

class LoginViewModel: NSObject, ObservableObject, LoginViewModelType {
    var sessionService: SessionService?
    
    // Variables for Input Validation
    @Published var isValidEmail = false
    @Published var isValidPassword = false
    @Published var showIntro = true
    
    // Protocol Implementation
    var service: LoginServiceType
    @Published var state: ServiceAPIState = .na
    @Published var userDetails: UserDetailsModel = .new
    var subscriptions = Set<AnyCancellable>()
    
    required init(service: LoginServiceType) {
        self.service = service
    }
    
    func signin() {
        self.state = .inprogress
        UIApplication.shared.endEditing()
        
        service.login(with: userDetails)
            .sink { [weak self] res in
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default:
                    break
                }
            } receiveValue: { [weak self] name in
                self?.userDetails.name = name
                self?.fetchBanks()
            }
            .store(in: &subscriptions)
    }
    
    func googleSignin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("Google Sign-in error: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
                 else {
                
                print("Google Sign-in failed: Unable to get tokens.")
                return
            }
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Firebase Sign-in error: \(error.localizedDescription)")
                    return
                }

                print("User is signed in with Google")
                self.userDetails.name = result?.user.displayName ?? ""
                self.userDetails.email = result?.user.email ?? ""
                self.fetchBanks()
            }
        }
    }
    
    func appleSignin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    private func saveUserDetails(details: UserDetailsModel, completion: @escaping((Error?) -> Void)) {
        let db = Firestore.firestore()
        let userDocument = db.collection(Constants.firestoreCollection.users).document(details.uid)
        
        userDocument.getDocument { (document, error) in
            if let error = error {
                completion(error)
                return
            }
            
            if let document = document, document.exists {
                completion(nil)
                return
            }
            
            // Data is different or document doesn't exist, proceed to update
            userDocument.setData([
                UserKeys.name.rawValue: details.name,
                UserKeys.email.rawValue: details.email
            ]) { error in
                completion(error)
            }
        }
    }
    
    func fetchBanks() {
        service.fetchBanks()
            .sink { [weak self] res in
                switch res {
                case .failure(let error):
                    self?.state = .failed(error: error)
                default:
                    break
                }
            } receiveValue: { [weak self] in
                guard let self else { return }
                self.state = .successful
                self.sessionService?.login(with: self.userDetails)
            }
            .store(in: &subscriptions)
    }
    
    func setupSession(session: SessionService) {
        self.sessionService = session
    }
}

extension LoginViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let identityToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }

            guard let identityTokenString = String(data: identityToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(identityToken.debugDescription)")
                return
            }

            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: identityTokenString, rawNonce: nil)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("Error in Apple Sign-in: \(error.localizedDescription)")
                    return
                }

                print("User is signed in with Apple")
                self.userDetails.name = result?.user.displayName ?? ""
                self.userDetails.email = result?.user.email ?? ""
                self.fetchBanks()
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple Sign-in failed: \(error.localizedDescription)")
    }
}

extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first!
    }
}
