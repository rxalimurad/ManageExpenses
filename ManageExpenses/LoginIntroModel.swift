//
//  LoginIntroModel.swift
//  ManageExpenses
//
//  Created by Ali Murad on 12/10/2022.
//

import Foundation


struct LoginIntroModel {
    var pages = [LoginIntroPage]()
    
}

struct LoginIntroPage: Identifiable {
    var id: String
    var title: String
    var desc: String
    var image: String

}


