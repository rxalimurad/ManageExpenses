//
//  SessionService.swift
//  ManageExpenses
//
//  Created by Ali Murad on 03/11/2022.
//

import Foundation
import Combine
import FirebaseAuth

enum SessionState {
    case loggedIn
    case loggedOut
}

protocol SessionServiceType {
    var state: SessionState { get }
    var userDetails: SessionUserDetails? { get }
    func logout()
}

class SessionService:ObservableObject, SessionServiceType {
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails?
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        setupFirebaseAuthHandler()
    }
    
    func logout() {
        
    }
}

private extension SessionService {
    func setupFirebaseAuthHandler() {
        handler = Auth.auth()
            .addStateDidChangeListener({ [weak self] res, user in
                guard let self = self else { return }
                self.state = user == nil ? .loggedOut : .loggedIn
                if let uid = user?.uid {
                    self.handleRefresh(with: uid)//,,..1
                }
            })
    }
    func handleRefresh(with uid: String) {
        //,,..2 update user in to main thread from firestre into userdetail object 
    }
    
}
