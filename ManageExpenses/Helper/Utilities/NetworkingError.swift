//
//  NetworkingError.swift
//  ManageExpenses
//
//  Created by murad on 05/11/2022.
//

import Foundation

struct NetworkingError: LocalizedError {
    var errorDescription: String
    init(_ msg: String) {
        errorDescription = msg
    }
}
