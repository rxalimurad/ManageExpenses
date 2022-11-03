//
//  ProfileView.swift
//  ManageExpenses
//
//  Created by murad on 25/10/2022.
//

import SwiftUI
import FirebaseAuth
struct ProfileView: View {
    @State var isLogoutShown = false
    @State var isAboutusShown = false
    @State var isCurrencyShown = false
    @State var isAccountsShown = false
    @State var currencySymbol = "$"
    @EnvironmentObject var sessionService: SessionService
    var safeAreaInsets: EdgeInsets
    var body: some View {
        ZStack {
            CustomColor.baseLight_60.edgesIgnoringSafeArea([.all])
            VStack {
                HStack {
                    ZStack {
                        Circle()
                            .strokeBorder(CustomColor.baseLight, lineWidth: 5)
                        Circle()
                            .strokeBorder(CustomColor.primaryColor, lineWidth: 2)
                        Image.Custom.apple
                            .resizable()
                            .frame(width: 76, height: 76)
                    }
                    .frame(width: 80, height: 80)
                    
                    VStack(alignment: .leading ,spacing: 8) {
                        Text("Username")
                            .foregroundColor(CustomColor.baseLight_20)
                            .font(.system(size: 14, weight: .medium))
                        Text("Ali Murad")
                            .foregroundColor(CustomColor.baseDark_75)
                            .font(.system(size: 24, weight: .semibold))
                    }
                    .padding([.leading], 10)
                    
                    Spacer()
                    Image.Custom.edit.hidden()
                }
                .padding([.horizontal], 20)
                .padding([.top], safeAreaInsets.top + 15)
                
                ZStack {
                    CustomColor.baseLight.edgesIgnoringSafeArea([.all])
                    VStack {
                        Button {
                            isAccountsShown.toggle()
                        } label: {
                            getSettingsCell(title: "Account", img: Image.Custom.account)
                        }

                        
                        Divider()
                        Button {
                            isCurrencyShown.toggle()
                        } label: {
                            getSettingsCell(title: "Currency", img: Image.Custom.settings)
                           
                        }
                        
                        Divider()
                        Button {
                            isAboutusShown.toggle()
                        } label: {
                            getAboutUsCell()
                        }

                        Divider()
                        Button {
                            isLogoutShown.toggle()
                        } label: {
                            getSettingsCell(title: "Logout", img: Image.Custom.logout)
                        }
                        
                    }
                }
                .cornerRadius(20)
                .padding([.horizontal], 20)
                .frame(maxHeight: 356)
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $isAboutusShown, onDismiss: {
            
        }, content: {
            AboutUsView()
        })
        .fullScreenCover(isPresented: $isAccountsShown, content: {
            BankAccountsView()
        })
        .fullScreenCover(isPresented: $isLogoutShown) {
            ZStack (alignment: .bottom) {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isLogoutShown.toggle()
                    }
                logoutSheet(safeAreaInsets)
            }
            .background(ColoredView(color: .clear))
            .edgesIgnoringSafeArea(.all)
        }
        .fullScreenCover(isPresented: $isCurrencyShown) {
            ZStack (alignment: .center) {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isCurrencyShown.toggle()
                    }
                currencySheet(safeAreaInsets)
                    .padding([.horizontal], 16)
                    
            }
            .background(ColoredView(color: .clear))
            .edgesIgnoringSafeArea(.all)
        }
        
        
    }
    
    func getAboutUsCell() -> some View {
        VStack {
            Spacer()
            HStack {
                ZStack {
                    CustomColor.primaryColor_20
                    Image.Custom.aboutus
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 30, height: 30)
                        .foregroundColor(CustomColor.primaryColor)
                }
                    .frame(width: 52, height: 52)
                    .cornerRadius(16)
                    .padding([.leading], 17)
                Text("About Us")
                    .foregroundColor(CustomColor.baseDark)
                Spacer()
            }
            Spacer()
        }
    }
    
    func getSettingsCell(title: String, img: Image) -> some View {
        VStack {
            Spacer()
            HStack {
                img
                    .padding([.leading], 17)
                Text(title)
                    .foregroundColor(CustomColor.baseDark)
                Spacer()
            }
            Spacer()
        }
    }
    
    
    private func logoutSheet(_ safeAreaInsets: EdgeInsets) ->  some View {
        VStack {
            Button {
                isLogoutShown.toggle()
            } label: {
                indicator
                    .padding([.top], 16)
            }

            Text("Logout?")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(CustomColor.baseDark)
                .padding([.top], 20)
            Text("Are you sure do you wanna logout?")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(CustomColor.baseLight_20)
                .padding([.horizontal], 16)
                .padding([.top], 20)
            
            HStack(spacing: 16) {
                ButtonWidgetView(title: "No", style: .secondaryButton) {
                    
                }
                ButtonWidgetView(title: "Yes", style: .primaryButton) {
                    try? Auth.auth().signOut()
                }
                
            }
            .padding([.top], 16)
            .padding([.horizontal], 16)
            .padding([.bottom], 16 + safeAreaInsets.top)
        }
        
        .background(ColoredView(color: .white))
        .cornerRadius(15, corners: [.topLeft, .topRight])
    }
    private func currencySheet(_ safeAreaInsets: EdgeInsets) ->  some View {
        VStack {
            Button {
                isCurrencyShown.toggle()
            } label: {
                indicator
                    .padding([.top], 16)
            }

            Text("Enter your currency symbol")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(CustomColor.baseDark)
                .padding([.top], 20)
           
            InputWidgetView(hint: "Currency Symbol", properties: InputProperties(maxLength: 3), text: $currencySymbol, isValidField: .constant(true))
                .padding([.horizontal], 16)
                .padding([.vertical], 16)
            HStack(spacing: 16) {
               ButtonWidgetView(title: "Done", style: .primaryButton) {
                   isCurrencyShown.toggle()
                }
                
            }
            .padding([.top], 16)
            .padding([.horizontal], 16)
            .padding([.bottom], 16 )
        }
        
        .background(ColoredView(color: .white))
        .cornerRadius(15)
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
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(safeAreaInsets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}
