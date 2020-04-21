//
//  RegisterView.swift
//  LoginRegister
//
//  Created by Joker on 2020/4/17.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    @State private var fn = ""
    @State private var ln = ""
    @State private var email = ""
    @State private var un = ""
    @State private var bd = ""
    @State private var pfU = ""
    @State private var pd = ""
    @State private var pd2 = ""
    @State private var rq = ""
    @State private var ra = ""
    @State private var userID = ""
    @State private var showAlert = false
    @State private var showSelectPhoto = false
    @State private var selectImage: UIImage?
    @ObservedObject var photoData = PhotoData()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(){
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack{
            List{
                HStack{
                    Image(systemName: "person.badge.plus")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("帳號").foregroundColor(.gray), text:$un)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "person")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("姓").foregroundColor(.gray), text:$ln)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "person")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("名").foregroundColor(.gray), text: $fn)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
                .padding()
                Button(action: {
                    self.showSelectPhoto = true
                }) {
                    Group {
                        if selectImage != nil {
                            Image(uiImage: selectImage!)
                                .resizable()
                                .renderingMode(.original)
                        } else {
                            Image(systemName: "photo")
                                .resizable()
                        }
                    }
                    .scaledToFill()
                    .frame(width: 310, height: 310)
                    .clipped()
                    .foregroundColor(.gray)
                    Text("選擇大頭貼")
                        .foregroundColor(.gray)
                }.padding()
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
                HStack{
                    Image(systemName: "clock")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("生日").foregroundColor(.gray), text: $bd)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("安全性問題").foregroundColor(.gray),text:$rq)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "questionmark.circle.fill")
                        .foregroundColor(Color.white)
                    CustomTextField(placeholder: Text("安全性答案").foregroundColor(.gray),text:$ra)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "lock")
                        .foregroundColor(Color.white)
                    CustomSecureField(placeholder: Text("密碼").foregroundColor(.gray),text:$pd)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
                .padding()
                HStack{
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color.white)
                    CustomSecureField(placeholder: Text("再次確認密碼").foregroundColor(.gray),text:$pd2)
                        .foregroundColor(.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
                .padding()
            }.background(Image("Background"))
                .sheet(isPresented: $showSelectPhoto) {
                    ImagePickerController(selectImage: self.$selectImage, showSelectPhoto: self.$showSelectPhoto)
            }
            Button("確認送出"){
                if self.pd != self.pd2{
                    self.showAlert = true
                }
                else{
                    if self.selectImage != nil {
                        ApiControl.shared.uploadImage(uiImage: self.selectImage!){
                            (result) in
                            switch result{
                            case .success(let uploadImageUrl):
                                self.pfU = uploadImageUrl
                                ApiControl.shared.RegisterAPI(Rfirstname: self.fn, Rlastname: self.ln, Remail: self.email, Rlogin: self.un, Rbirthday: self.bd, Rprofilurl: self.pfU, Rpassword: self.pd){
                                    (result) in
                                    switch result {
                                    case .success(let userstatus):
                                        ApiControl.shared.ChangeRecoveryQuestionAPI(UserID: userstatus.id, UserPassword: self.pd, UserRQ: self.rq, UserRA: self.ra){
                                            (result) in
                                            switch result {
                                            case .success( _):
                                                print("CRQ changed.")
                                                self.presentationMode.wrappedValue.dismiss()
                                            case .failure( _):
                                                print("CRQ Error.")
                                                break
                                            }
                                        }
                                    case .failure( _):
                                        self.showAlert = true
                                    }
                                }
                            case .failure( _):
                                ApiControl.shared.RegisterAPI(Rfirstname: self.fn, Rlastname: self.ln, Remail: self.email, Rlogin: self.un, Rbirthday: self.bd, Rprofilurl: self.pfU, Rpassword: self.pd){
                                    (result) in
                                    switch result {
                                    case .success(let userstatus):
                                        ApiControl.shared.ChangeRecoveryQuestionAPI(UserID: userstatus.id, UserPassword: self.pfU, UserRQ: self.rq, UserRA: self.ra){
                                            (result) in
                                            switch result {
                                            case .success( _):
                                                print("CRQ changed.")
                                                self.presentationMode.wrappedValue.dismiss()
                                            case .failure( _):
                                                print("CRQ Error.")
                                                break
                                            }
                                        }
                                    case .failure( _):
                                        self.showAlert = true
                                    }
                                }
                                print("Cannot get the image url.")
                            }
                        }
                    }
                    else {
                        print("No selectImage!!")
                        ApiControl.shared.RegisterAPI(Rfirstname: self.fn, Rlastname: self.ln, Remail: self.email, Rlogin: self.un, Rbirthday: self.bd, Rprofilurl: self.pfU, Rpassword: self.pd){
                            (result) in
                            switch result {
                            case .success(let userstatus):
                                ApiControl.shared.ChangeRecoveryQuestionAPI(UserID: userstatus.id, UserPassword: self.pfU, UserRQ: self.rq, UserRA: self.ra){
                                    (result) in
                                    switch result {
                                    case .success( _):
                                        print("CRQ changed.")
                                        self.presentationMode.wrappedValue.dismiss()
                                    case .failure( _):
                                        print("CRQ Error.")
                                        break
                                    }
                                }
                            case .failure( _):
                                self.showAlert = true
                            }
                        }
                        
                    }
                }
            }.font(.system(size: 30))
                .frame(width:310)
                .padding(.all, 10)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red:91/255,green:191/255,blue:236/255), Color(red:250/255,green:191/255,blue:221/255)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15)
                //.padding(.leading, 22)
                .alert(isPresented: $showAlert){() -> Alert in
                        return Alert(title: Text("帳號註冊錯誤!!"))
                }
        }
    }
}
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

struct CustomSecureField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            SecureField("", text: $text)
        }
    }
}
