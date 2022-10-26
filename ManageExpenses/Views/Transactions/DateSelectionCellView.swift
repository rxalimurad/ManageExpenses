//
//  DateSelectionCellView.swift
//  ManageExpenses
//
//  Created by murad on 26/10/2022.
//

import SwiftUI

struct DateSelectionCellView: View {
    var title: String
    var action: () -> Void
    @State var date = Date()
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(CustomColor.primaryColor)
                .padding([.top], 15)
            VStack {
                
                DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
                    
                }.labelsHidden()
                    .accentColor(CustomColor.primaryColor)
            }
            
            .padding([.top], 20)
            .padding([.bottom], 16)
            .frame(maxWidth: .infinity)
        }
        .background(ColoredView(color: CustomColor.primaryColor.opacity(0.2)))
        .cornerRadius(10)
        .onTapGesture {
            action()
        }
        
    }
}

struct DateSelectionCellView_Previews: PreviewProvider {
    static var previews: some View {
        DateSelectionCellView(title: "fd") {}
    }
}
