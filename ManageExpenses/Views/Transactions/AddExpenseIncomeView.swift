//
//  AddExpenseIncomeView.swift
//  ManageExpenses
//
//  Created by Ali Murad on 18/10/2022.
//

import SwiftUI

struct AddExpenseIncomeView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State var showAmtKeybd = false
    @State var isRepeated = false
    @State var isAtchmntViewShown = false
    @State var selectedImage: Image?
    @State var isImgPkrShown = false
    @State var isCamerPkrShown = false
    @State var isCategoryshown = false
    @State var amount = ""
    @State private var phase = 0.0
    
    
    var newEntryType: PlusMenuAction
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                NavigationBar(title: getTitle(type: newEntryType), top: geometry.safeAreaInsets.top) {
                    mode.wrappedValue.dismiss()
                }
               
                Text("Income")
                    .foregroundColor(CustomColor.baseLight_80.opacity(0.64))
                    .font(.system(size: 18, weight: .medium))
                    .padding([.leading], 26)
                AmountInputWidget(amount: amount)
                    .font(.system(size: 64, weight: .medium))
                    .foregroundColor(CustomColor.baseLight)
                    .padding([.top], 13)
                    .onTapGesture {
                        withAnimation {
                            showAmtKeybd.toggle()
                        }
                    }
                
               Spacer()
            }
            .overlay(addDetailsView(geometry),alignment: .bottom)
            .overlay(KeyboardWidget(geometry: geometry, amount: $amount, isShowing: $showAmtKeybd), alignment: .center)
            .fullScreenCover(isPresented: $isAtchmntViewShown) {
                ZStack (alignment: .bottom) {
                    Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isAtchmntViewShown.toggle()
                        }
                    attachmentSheet(geometry)
                }
                .background(ColoredView(color: .clear))
                .edgesIgnoringSafeArea(.all)
            }
            .fullScreenCover(isPresented: $isCategoryshown) {
                ZStack (alignment: .bottom) {
                    Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isCategoryshown.toggle()
                        }
                    getCategoryPicker(geometry)
                }
                .background(ColoredView(color: .clear))
                .edgesIgnoringSafeArea(.all)
            }
            .background(
                Rectangle()
                    .foregroundColor(getBgColor(type: newEntryType))
                
            )
            .sheet(isPresented: $isImgPkrShown, content: {
                ImagePicker(image: $selectedImage, type: .photoLibrary)
            })
            .sheet(isPresented: $isCamerPkrShown, content: {
                ImagePicker(image: $selectedImage, type: .camera)
            })
            .edgesIgnoringSafeArea([.all])
            
        }
    }
    
    
    private func addDetailsView(_ geometry: GeometryProxy) -> some View {
        VStack {
            SelectorWidgetView(hint: "Category", text: .constant(""))
                .padding([.top], 24)
            InputWidgetView(hint: "Description", properties: InputProperties(maxLength: 10), text: .constant(""))
                .padding([.top], 16)
            SelectorWidgetView(hint: "Wallet", text: .constant(""))
                .padding([.top, .bottom], 16)
            if selectedImage == nil {
                HStack(alignment: .center) {
                    HStack(spacing: 10) {
                        Image.Custom.attachment
                        Text("Add Attachment")
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.vertical], 16)
                    
                }.onTapGesture {
                    withAnimation {
                        isAtchmntViewShown.toggle()
                    }
                }.background(
                    Rectangle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6], dashPhase: phase))
                        .foregroundColor(CustomColor.baseLight_20)
                        .cornerRadius(5)
                )
            } else {
                HStack {
                    ZStack(alignment: .topTrailing) {
                        selectedImage?
                            .resizable()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                        Button {
                            withAnimation {
                                selectedImage = nil
                            }
                        } label: {
                            Image.Custom.grayCross
                                .resizable()
                                .frame(width: 24, height: 24)
                                .offset(x: 12, y: -12)
                        }

                            
                    }
                    Spacer()
                }
            }
            
            
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Repeat")
                        .font(.system(size: 16))
                        .foregroundColor(CustomColor.baseDark_25)
                    
                    Text("Repeat Transaction")
                        .font(.system(size: 13))
                        .foregroundColor(CustomColor.baseLight_20)
                }
                .padding([.leading], 16)
                Toggle("", isOn: $isRepeated)
                
            }
            .padding([.vertical], 16)
            
            ButtonWidgetView(title: "Continue", style: .primaryButton) {
                
            }
            .padding([.top], 24)
            .padding([.bottom], geometry.safeAreaInsets.bottom +  16)
        }
        .padding([.horizontal], 16)
        .cornerRadius(30, corners: [.topLeft, .topRight])
        .background(
            RoundedCorner(radius: 30)
                .foregroundColor(CustomColor.baseLight)
        )
    
    }
    private func getCategoryPicker(_ geometry: GeometryProxy) ->  some View {
        VStack {
            indicator
                .onTapGesture {
                    isAtchmntViewShown.toggle()
                }
                .padding([.top], 16)
                .padding([.bottom], 48)
            HStack(spacing: 8) {
                AttachmentView(image: .Custom.camera, title: "Camera") {
                    isAtchmntViewShown.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.isCamerPkrShown.toggle()
                    }
                }
                AttachmentView(image: .Custom.gallery, title: "Image") {
                    isAtchmntViewShown.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.isImgPkrShown.toggle()
                    }
                }
               
            }
            .padding([.horizontal], 16)
            .padding([.bottom], 16 + geometry.safeAreaInsets.bottom)
        }
        
        .background(ColoredView(color: .white))
        .cornerRadius(15, corners: [.topLeft, .topRight])
    }
    private func attachmentSheet(_ geometry: GeometryProxy) ->  some View {
        VStack {
            indicator
                .onTapGesture {
                    isAtchmntViewShown.toggle()
                }
                .padding([.top], 16)
                .padding([.bottom], 48)
            HStack(spacing: 8) {
                AttachmentView(image: .Custom.camera, title: "Camera") {
                    isAtchmntViewShown.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.isCamerPkrShown.toggle()
                    }
                }
                AttachmentView(image: .Custom.gallery, title: "Image") {
                    isAtchmntViewShown.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.isImgPkrShown.toggle()
                    }
                }
               
            }
            .padding([.horizontal], 16)
            .padding([.bottom], 16 + geometry.safeAreaInsets.bottom)
        }
        
        .background(ColoredView(color: .white))
        .cornerRadius(15, corners: [.topLeft, .topRight])
    }
    
    private var indicator: some View {
        Rectangle()
            .foregroundColor(CustomColor.primaryColor)
            .cornerRadius(Constants.bottomSheet.radius)
            .frame(
                width: Constants.bottomSheet.indicatorWidth,
                height: Constants.bottomSheet.indicatorHeight
            )
    }
    
    func getTitle(type: PlusMenuAction) -> String {
        switch type {
        case .income:
            return  "Income"
        case .expense:
            return  "Expense"
        case .convert:
            return  "Transfer"
        }
    }
    func getBgColor(type: PlusMenuAction) -> Color {
        switch type {
        case .income:
            return  CustomColor.green
        case .expense:
            return  CustomColor.red
        case .convert:
            return  CustomColor.blue
        }
    }
    
    
}

struct AddExpenseIncomeView_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseIncomeView(newEntryType: .income)
    }
}

