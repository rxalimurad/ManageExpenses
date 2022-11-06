//
//  SignupService.swift
//  ManageExpenses
//
//  Created by Ali Murad on 03/11/2022.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore


protocol SignupServiceType {
    func signup(with details: UserDetailsModel) -> AnyPublisher<Void, NetworkingError>
}

final class SignupService: SignupServiceType {
    func signup(with details: UserDetailsModel) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future {promise in
                Auth.auth().createUser(withEmail: details.email, password: details.password) {[weak self] res, error  in
                    if let err = error {
                        promise(.failure(NetworkingError(err.localizedDescription)))
                    } else {
                        res?.user.sendEmailVerification(completion: { error in
                            if let err  = error {
                                promise(.failure(NetworkingError(err.localizedDescription)))
                            } else {
                                self?.saveUserDetails(details: details) { error in
                                    if let err  = error {
                                        promise(.failure(NetworkingError(err.localizedDescription)))
                                    } else {
                                        promise(.success(()))
                                    }
                                }
                            }
                        })
                        
                    }
                }
            }
            
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    private func saveUserDetails(details: UserDetailsModel, completion: @escaping((Error?) -> Void)) {
        let db = Firestore.firestore()
        db.collection(Constants.firestoreCollection.users)
            .document(details.email)
            .setData([UserKeys.name.rawValue : details.name, UserKeys.email.rawValue : details.email]) { error in
                completion(error)
            }
        
    }
}


