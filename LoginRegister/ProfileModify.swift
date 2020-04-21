//
//  ProfileModify.swift
//  LoginRegister
//
//  Created by Joker on 2020/4/18.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

struct ProfileModify: View {
    @State private var fn = ""
    @State private var ln = ""
    @State private var email = ""
    @State private var bd = ""
    @State private var pfU = ""
    @State private var showAlertError = false
    @State private var showSelectPhoto = false
    @State private var selectImage: UIImage?
    @State private var content = ""
    @State var userID:String
    @ObservedObject var photoData = PhotoData()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            List{
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
            }.background(Image("Background"))
                .onAppear{
                    UITableView.appearance().separatorColor = .clear
                    UITableView.appearance().backgroundColor = .clear
                    UITableViewCell.appearance().backgroundColor = .clear
            }
            .sheet(isPresented: $showSelectPhoto) {
                ImagePickerController(selectImage: self.$selectImage, showSelectPhoto: self.$showSelectPhoto)}
            Button("確認送出"){
                if self.selectImage != nil {
                    ApiControl.shared.uploadImage(uiImage: self.selectImage!){
                        (result) in
                        switch result {
                        case .success(let uploadImageUrl):
                            self.pfU = uploadImageUrl
                            ApiControl.shared.ModifyProfileAPI(userID: self.userID, Mfirstname: self.fn, Mlastname: self.ln, Mprofileurl: self.pfU, Mbirthday: self.bd){
                                (result) in
                                switch result{
                                case .success(let MProfile):
                                    print("modify success!!")
                                    self.presentationMode.wrappedValue.dismiss()
                                case .failure( _):
                                    self.showAlertError = true
                                }
                            }
                        case .failure( _):
                            print("Cannot get the image url.")
                        }
                    }
                }
                else {
                    ApiControl.shared.ModifyProfileAPI(userID: self.userID, Mfirstname: self.fn, Mlastname: self.ln, Mprofileurl: self.pfU, Mbirthday: self.bd){
                        (result) in
                        switch result{
                        case .success(let MProfile):
                            self.presentationMode.wrappedValue.dismiss()
                        case .failure( _):
                            self.showAlertError = true
                        }
                    }
                }
            }.font(.system(size: 30))
                .frame(width:310)
                .padding(.all, 10)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red:91/255,green:191/255,blue:236/255), Color(red:250/255,green:191/255,blue:221/255)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15)
                .alert(isPresented: $showAlertError){() -> Alert in
                    return Alert(title: Text("修改錯誤 請重新輸入!!"))
            }
        }
    }
}


struct ProfileModify_Previews: PreviewProvider {
    static var previews: some View {
        ProfileModify(userID: "00u941uf62qbYVvo94x6")
    }
}
