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
                                var detailToSave = details
                                detailToSave.uid = res?.user.uid ?? ""
                                self?.saveUserDetails(details: detailToSave) { error in
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

}


