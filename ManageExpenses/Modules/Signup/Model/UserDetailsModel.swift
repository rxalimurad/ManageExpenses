//
//  UserDetailsModel.swift
//  ManageExpenses
//
//  Created by Ali Murad on 03/11/2022.
//

import Foundation

struct UserDetailsModel {
    var name: String
    var uid: String
    var email: String
    var password: String
}

extension UserDetailsModel {
    static var new: UserDetailsModel {
        UserDetailsModel(name: "", uid: "", email: "", password: "")
    }
}
