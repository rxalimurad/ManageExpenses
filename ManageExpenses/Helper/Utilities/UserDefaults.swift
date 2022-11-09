//
//  UserDefaults.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import Foundation

extension UserDefaults {
    
    var currentUser: SessionUserDetails?  {
        get {
            if let data = UserDefaults.standard.data(forKey: Constants.persistanceKey.currentUser) {
                let decoder = JSONDecoder()
                return try? decoder.decode(SessionUserDetails.self, from: data)
            }
            return nil
        }
        set {
            let encoder = JSONEncoder()
            let data = try? encoder.encode(newValue)
            UserDefaults.standard.set(data, forKey: Constants.persistanceKey.currentUser)
        }
    }
    var currency: String  {
        get {
            if let currency = UserDefaults.standard.string(forKey: Constants.persistanceKey.currency) {
                return currency
            }
            return "$"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.persistanceKey.currency)
        }
    }

    
    
}
