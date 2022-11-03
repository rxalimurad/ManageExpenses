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
    func signup(with details: UserDetailsModel) -> AnyPublisher<Void, Error>
}

final class SignupService: SignupServiceType {
    func signup(with details: UserDetailsModel) -> AnyPublisher<Void, Error> {
        Deferred {
            Future {promise in
                Auth.auth().createUser(withEmail: details.email, password: details.password) {[weak self] res, error  in
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        self?.saveUserDetails(details: details) { error in
                            if let err  = error {
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
    
    private func saveUserDetails(details: UserDetailsModel, completion: @escaping((Error?) -> Void)) {
        let db = Firestore.firestore()
        _ = db.collection(Constants.firestoreCollection.users)
            .addDocument(data: [UserKeys.name.rawValue : details.name]) { error in
                completion(error)
            }
        
    }
}


