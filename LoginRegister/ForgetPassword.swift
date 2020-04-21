//
//  ForgetPassword.swift
//  LoginRegister
//
//  Created by Joker on 2020/4/20.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

struct ForgetPassword: View {
    @State private var userID = ""
    @State private var un = ""
    @State private var email = ""
    @State private var showAlertError = false
    @State private var showWebpage = false
    @State private var fpURL = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            List{
                HStack{
                    Image(systemName: "person.badge.plus")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("帳號").foregroundColor(.gray), text: $un)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "envelope")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("電子信箱").foregroundColor(.gray), text: $email)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
                .padding()
            }.padding(.top, 250)
                .onAppear{
                    UITableView.appearance().separatorColor = .clear
                    UITableView.appearance().backgroundColor = .clear
                    UITableViewCell.appearance().backgroundColor = .clear
            }
            Button("確認送出"){
                ApiControl.shared.GetAllUserAPI(UserName: self.un, UserEmail: self.email){
                    (result) in
                    switch result{
                    case .success(let userID):
                        self.userID = userID
                        ApiControl.shared.ForgetPasswordAPI(UserID: self.userID){
                            (result) in
                            switch result {
                            case .success(let fpURL):
                                self.fpURL = fpURL
                                self.showWebpage = true
                            case .failure( _):
                                print("Cannot get the FPurl.")
                            }
                        }
                    case .failure( _):
                        self.showAlertError = true
                    }
                }}.font(.system(size: 30))
                .frame(width:310)
                .padding(.all, 10)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red:91/255,green:191/255,blue:236/255), Color(red:250/255,green:191/255,blue:221/255)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15)
                .alert(isPresented: $showAlertError){() -> Alert in
                    return Alert(title: Text("錯誤的帳號.電子信箱!!"))
            }.sheet(isPresented: $showWebpage) {
                SafariView(url: URL(string: self.fpURL)!)
            }
        }.background(Image("Background"))
    }
}

struct ForgetPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgetPassword()
    }
}

