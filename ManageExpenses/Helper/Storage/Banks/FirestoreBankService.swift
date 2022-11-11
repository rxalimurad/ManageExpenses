//
//  FirestoreBankService.swift
//  ManageExpenses
//
//  Created by Ali Murad on 11/11/2022.
//

import Foundation
import Combine
import FirebaseFirestore

protocol BankServiceType {
    func getBanksList() -> AnyPublisher<[SelectDataModel], NetworkingError>
    func saveBank(bank: SelectDataModel) -> AnyPublisher<Void, NetworkingError>
    
}

class FirestoreBankService: BankServiceType {
    func getBanksList() -> AnyPublisher<[SelectDataModel], NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                db.collection(Constants.firestoreCollection.banks)
                    .getDocuments { snapshot, error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            if let documents = snapshot?.documents, !documents.isEmpty {
                                var banks = [SelectDataModel]()
                                for document in documents {
                                    banks.append(SelectDataModel.new.fromFireStoreData(data: document.data()))
                                }
                                promise(.success(banks))
                                
                            } else {
                                promise(.failure(NetworkingError("No Bank Found")))
                            }
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
    func saveBank(bank: SelectDataModel) -> AnyPublisher<Void, NetworkingError> {
        Deferred {
            Future { promise in
                let db = Firestore.firestore()
                db.collection(Constants.firestoreCollection.banks)
                    .document(bank.id)
                    .setData(bank.toFireStoreData()){ error in
                        if let err = error {
                            promise(.failure(NetworkingError(err.localizedDescription)))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
    
}
