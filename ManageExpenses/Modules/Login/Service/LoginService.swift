//
//  LoginService.swift
//  ManageExpenses
//
//  Created by murad on 04/11/2022.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

protocol LoginServiceType {
    func login(with details: UserDetailsModel) -> AnyPublisher<Void, NetworkingError>
}

class LoginService: LoginServiceType {
    func login(with details: UserDetailsModel) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                Auth.auth().signIn(withEmail: details.email, password: details.password) {[weak self] res, error  in
                    if let err = error {
                        promise(.failure(NetworkingError(err.localizedDescription)))
                    } else {
                        self?.checkEmailVerifed(res?.user.isEmailVerified) { verificationError in
                            if let err = verificationError {
                                promise(.failure(err))
                            } else {
                                promise(.success(()))
                            }
                        }
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func checkEmailVerifed(_ isEmailVerified: Bool? , completion: @escaping((NetworkingError?) -> Void)) {
        if let isEmailVerified = isEmailVerified, isEmailVerified {
            completion(nil)
        } else {
            completion(NetworkingError("Kindly verify your email before loggin in."))
        }
    }
}
