//
//  ForgotPasswordService.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//


import Foundation
import Combine
import FirebaseAuth


protocol ForgotPasswordServiceType {
    func reset(email: String) -> AnyPublisher<Void, NetworkingError>
}

class ForgotPasswordService: ForgotPasswordServiceType {
    func reset(email: String) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if let err =  error {
                        promise(.failure(NetworkingError(err.localizedDescription)))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
}
