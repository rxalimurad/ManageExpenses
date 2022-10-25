//
//  AddExpenseIncomeViewModel.swift
//  ManageExpenses
//
//  Created by Ali Murad on 25/10/2022.
//
import Foundation
import Combine
import CoreData
import SwiftUI

class AddExpenseIncomeViewModel: ObservableObject {
    func saveTransaction(
        context:NSManagedObjectContext,
        amount: String,
        name: String,
        desc: String,
        type: String,
        category: String,
        wallet: String,
        image: Image?
    ){
        let trans = Transaction(context: context)
        trans.transAmount = PlusMenuAction(rawValue: type) == .expense ? -(Double(amount) ?? 0) : (Double(amount) ?? 0)
        trans.transDesc = desc
        trans.transName = name
        trans.transType = type
        trans.wallet = wallet
        trans.id = UUID()
        trans.category = category
        trans.date = Date()
        trans.image = image.asUIImage().jpegData(compressionQuality: 0.3)
        save(context: context)
     
    }
    
    private func save(context: NSManagedObjectContext){
        do{
            try context.save()
        }
        catch{
            print(error)
        }
    }
    
    func editList(trans: Transaction){
     
    }
    
    func delete(trans: Transaction, context:NSManagedObjectContext){
        context.delete(trans)
        save(context: context)
    }
}
