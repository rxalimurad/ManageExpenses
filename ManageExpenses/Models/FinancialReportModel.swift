//
//  FinancialReportModel.swift
//  ManageExpenses
//
//  Created by murad on 30/10/2022.
//

import Foundation

struct FinanicalReportModel: Identifiable {
    var id = UUID()
    var category: SelectDataModel
    var amount: Double
    var total: Double
}
