//
//  ForgotPasswordService.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//


import Foundation
import Combine
//import FirebaseAuth


protocol ForgotPasswordServiceType {
    func reset(email: String) -> AnyPublisher<Void, NetworkingError>
}

class ForgotPasswordService: ForgotPasswordServiceType {
    func reset(email: String) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                promise(.success(()))
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
}
