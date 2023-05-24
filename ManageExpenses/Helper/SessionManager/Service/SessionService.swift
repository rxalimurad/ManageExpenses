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
    func login(with userDetails: UserDetailsModel)
}

class SessionService:ObservableObject, SessionServiceType {
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails?
    
    init() {
        checkForUser()
    }
    
    func logout() {
        try? Auth.auth().signOut()
        userDetails = nil
        UserDefaults.standard.currentUser = userDetails
        state = .loggedOut
        
    }
    func login(with userDetails: UserDetailsModel) {
        self.userDetails = SessionUserDetails(name: userDetails.name, email: userDetails.email)
        UserDefaults.standard.currentUser = self.userDetails
        self.state = .loggedIn
    }
    
    func checkForUser() {
        if let currentUser = UserDefaults.standard.currentUser {
            self.state = .loggedIn
            self.userDetails = currentUser
        } else {
            self.state = .loggedOut
            self.userDetails = nil
        }
    }
}

