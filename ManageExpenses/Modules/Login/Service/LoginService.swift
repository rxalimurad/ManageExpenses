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
    func login(with details: UserDetailsModel) -> AnyPublisher<String, NetworkingError>
    func fetchBanks() -> AnyPublisher<Void, NetworkingError>
}
                                                                                                                                                      
class LoginService: LoginServiceType {
    
    func login(with details: UserDetailsModel) -> AnyPublisher<String, NetworkingError> {
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
                                self?.fetchUserDetails(uid: res?.user.uid ?? "", completion: { name in
                                    
                                    promise(.success(name))
                                })
                                
                            }
                        }
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func fetchUserDetails(uid: String, completion: @escaping ((String)->Void)) {
        let db = Firestore.firestore()
        db.collection(Constants.firestoreCollection.users)
            .document(uid)
            .getDocument { snapshot, error in
                if let _ = error {
                    completion("Unknown")
                } else {
                    if let document = snapshot, document.exists {
                        let name = (document.data()?["name"] as? String) ?? "Unknown"
                        completion(name)
                    }
                }
            }
    }
    func fetchBanks() -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                guard let uid = Auth.auth().currentUser?.uid else {
                    promise(.failure(NetworkingError("User not authenticated")))
                    return
                }
                let db = Firestore.firestore()

                let userRef = db.collection(Constants.firestoreCollection.users).document(uid)
                userRef.collection(Constants.firestoreCollection.banks)
                    .getDocuments { snap, error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            if let documents = snap?.documents, !documents.isEmpty {
                                var banks = [SelectDataModel]()
                                for doc in documents {
                                    banks.append(SelectDataModel.getNewBankAccount().fromFireStoreData(data: doc.data()))
                                }
                                DataCache.shared.banks = banks
                                promise(.success(()))
                                
                            } else {
                                promise(.success(()))
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
