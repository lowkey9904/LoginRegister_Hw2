//
//  PasswordModify.swift
//  LoginRegister
//
//  Created by Joker on 2020/4/19.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

struct PasswordModify: View {
    @State private var opd = ""
    @State private var npd = ""
    @State private var npd2 = ""
    @State var userID:String
    @State private var showAlertError = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        VStack{
            List{
            
            HStack{
                Image(systemName: "lock")
                    .foregroundColor(Color.white)
                CustomSecureField(placeholder: Text("舊密碼").foregroundColor(.gray), text: $opd)
                    .foregroundColor(.white)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
            .padding()
            HStack{
                Image(systemName: "lock")
                    .foregroundColor(Color.white)
                CustomSecureField(placeholder: Text("新密碼").foregroundColor(.gray), text: $npd)
                    .foregroundColor(.white)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
            .padding()
            HStack{
                Image(systemName: "lock")
                    .foregroundColor(Color.white)
                CustomSecureField(placeholder: Text("再次確認新密碼").foregroundColor(.gray), text: $npd2)
                    .foregroundColor(.white)
            }
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
            .padding()
            .padding(.bottom, 30)
            }.padding(.top, 210)
            Button("確認送出"){
                if self.npd == self.npd2{
                    ApiControl.shared.ModifyPasswordAPI(userID: self.userID, oldPassword: self.opd, newPassword: self.npd){
                        (result) in
                        switch result{
                        case .success( _):
                            print("modify success!!")
                            self.presentationMode.wrappedValue.dismiss()
                        case .failure( _):
                            print("modify fail!!")
                            self.showAlertError = true
                        }
                    }
                }
                else {
                    self.showAlertError = true
                }
            }.font(.system(size: 30))
                .frame(width:310)
                .padding(.all, 10)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red:91/255,green:191/255,blue:236/255), Color(red:250/255,green:191/255,blue:221/255)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15)
                .alert(isPresented: $showAlertError){() -> Alert in
                    return Alert(title: Text("密碼錯誤或兩次密碼不一致!!"))
            }
        }.background(Image("Background"))
    }
}

struct PasswordModify_Previews: PreviewProvider {
    static var previews: some View {
        PasswordModify(userID: "")
    }
}
