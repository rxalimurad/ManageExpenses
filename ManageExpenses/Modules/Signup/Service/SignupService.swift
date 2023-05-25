//
//  SignupService.swift
//  ManageExpenses
//
//  Created by Ali Murad on 03/11/2022.
//

import Foundation
import Combine
//import FirebaseAuth


protocol SignupServiceType {
    func signup(with details: UserDetailsModel) -> AnyPublisher<Void, NetworkingError>
}

final class SignupService: SignupServiceType {
    func signup(with details: UserDetailsModel) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                promise(.success(()))
            }
            
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    private func saveUserDetails(details: UserDetailsModel, completion: @escaping((Error?) -> Void)) {
        completion(nil)

    }
}


