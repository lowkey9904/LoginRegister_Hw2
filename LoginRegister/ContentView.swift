//
//  ContentView.swift
//  LoginRegister
//
//  Created by Joker on 2020/4/15.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var un = ""
    @State private var pd = ""
    @State private var loginID = ""
    @State private var nowTimeHour = 0
    @State private var weatherIcon = "sun.max"
    @State private var weatherUpdateTime = ""
    @State private var weatherlocationName = ""
    @State private var weatherTheDayHT = ""
    @State private var weatherTheDayLT = ""
    @State private var weatherTheDayT = ""
    @State private var weatherTheDayH = ""
    @State private var showAlert = false
    @State private var showView = false
    @State private var showProfileView = false
    @State private var showRegisterView = false
    @State private var showForgetPasswordView = false
    @State var usertokenID:String
    @State var userID:String
    @State var userConGetProfile:UGProfileDec
    
    var body: some View {
        NavigationView{
            VStack{
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName: self.weatherIcon)
                        .resizable()
                        .scaledToFill()
                            .frame(width: 55, height: 55)
                        //.clipped()
                    Text(weatherlocationName + "今日天氣")
                        .font(.system(size: 25))
                    }.padding(.bottom, 30)
                    Text("今日高溫：" + weatherTheDayHT + "°C")
                    Text("今日低溫：" + weatherTheDayLT + "°C")
                    Text("現在溫度：" + weatherTheDayT + "°C")
                    Text("現在濕度：" + weatherTheDayH + "%")
                }
                .foregroundColor(Color(red: 195/255, green: 233/255, blue: 233/255))
                .font(.system(size: 20))
                .padding(.trailing, 150)
                HStack{
                    Image(systemName: "person")
                        .foregroundColor(Color.white)
                    Text("帳號")
                        .foregroundColor(Color.white)
                    TextField("", text: $un)
                        .foregroundColor(Color.white)
                }.padding()
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
                    .padding()
                HStack{
                    Image(systemName: "lock")
                        .foregroundColor(Color.white)
                    Text("密碼")
                        .foregroundColor(Color.white)
                    SecureField("Password", text:$pd)
                        .foregroundColor(Color.white)
                }
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color(red: 231/255, green: 161/255, blue: 205/255), lineWidth: 2))
                .padding()
                .padding(.bottom, 30)
                
                VStack{
                    Button(action: {
                        ApiControl.shared.LoginAPI(LoginUserName: self.un, LoginPassWord: self.pd){
                            (result) in
                            switch result {
                            case .success(let userProfile):
                                self.usertokenID = userProfile.sessionToken
                                self.userID = userProfile._embedded.user.id
                                userDefaults.set(userProfile._embedded.user.id, forKey: "userLoginAPPID")
                                print("Loing Get the AppID:" + userDefaults.string(forKey: "userLoginAPPID")!)
                                ApiControl.shared.GetProfileAPI(UserID: self.userID){
                                    (result) in
                                    switch result{
                                    case .success(let userGetProfile):
                                        self.userConGetProfile = userGetProfile
                                        self.showProfileView = true
                                    case .failure( _):
                                        break
                                    }
                                }
                            case .failure( _):
                                self.showAlert = true
                            }
                        }
                    }) {
                        Text("登入")
                            .font(.system(size: 30))
                            .frame(width:310)
                            .padding(.all, 10)
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(red:91/255,green:191/255,blue:236/255), Color(red:250/255,green:191/255,blue:221/255)]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(15)
                    }.alert(isPresented: $showAlert){() -> Alert in
                        return Alert(title: Text("帳號或密碼錯誤!!"))}
                        .padding(.bottom, 20)
                    NavigationLink(destination: ProfileView(userGetProfile: self.userConGetProfile), isActive: $showProfileView){
                        EmptyView()
                    }
                    Button(action:{
                        self.showRegisterView = true
                    }){
                        Text("註冊")
                        .font(.system(size: 30))
                        .frame(width:310)
                        .padding(.all, 10)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red:91/255,green:191/255,blue:236/255), Color(red:250/255,green:191/255,blue:221/255)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                    }.padding(.bottom, 20)
                    .sheet(isPresented: $showRegisterView){RegisterView()}
                    Button(action:{
                        self.showForgetPasswordView = true
                    }){
                        Text("忘記密碼")
                        .font(.system(size: 30))
                        .frame(width:310)
                        .padding(.all, 10)
                        .foregroundColor(.white)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red:91/255,green:191/255,blue:236/255), Color(red:250/255,green:191/255,blue:221/255)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                    }.padding(.bottom, 20)
                    .sheet(isPresented: $showForgetPasswordView){ForgetPassword()}
                }
            }.background(Image("Background"))
                .navigationBarTitle(Text("專屬於你的-星座APP").bold())
        }.onAppear{
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(red: 195/255, green: 233/255, blue: 233/255, alpha: 1)]
            self.AutoLogin()
            userDefaults.set("unknown", forKey: "userLoginAPPID")
            self.GetWeather()
            self.nowTimeHour =  self.GetTime()
            self.weatherIcon = self.ShowTheWeatherIcon(nowTime: self.nowTimeHour)
        }
    }
    
    func GetWeather() -> Void{
        ApiControl.shared.GetWeatherToday(locationName: "基隆"){
            (result) in
            switch result{
            case .success(let weatherDec):
                print("Get Weather!!")
                self.weatherlocationName = weatherDec.cwbopendata.location[0].locationName
                self.weatherTheDayHT = weatherDec.cwbopendata.location[0].weatherElement[14].elementValue.value
                self.weatherTheDayLT = weatherDec.cwbopendata.location[0].weatherElement[16].elementValue.value
                self.weatherTheDayT = weatherDec.cwbopendata.location[0].weatherElement[3].elementValue.value
                if(weatherDec.cwbopendata.location[0].weatherElement[4].elementValue.value == "1"){
                    self.weatherTheDayH = weatherDec.cwbopendata.location[0].weatherElement[4].elementValue.value + "00"
                }
                else{
                    self.weatherTheDayH = String(weatherDec.cwbopendata.location[0].weatherElement[4].elementValue.value.dropFirst(2))
                }
            case .failure( _):
                print("ERROR")
            }
        }
    }
    
    func GetTime() -> Int{
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        //let minutes = calendar.component(.minute, from: date)
        //print(minutes)
        return hour
    }
    
    func ShowTheWeatherIcon(nowTime:Int) -> String {
        if nowTime >= 6 && nowTime <= 18{
            return "sun.max"
        }
        else{
            return "moon.stars"
        }
    }
    
    func AutoLogin() -> Void {
        if userDefaults.string(forKey: "userLoginAPPID")! != "unknown" {
            ApiControl.shared.GetProfileAPI(UserID: userDefaults.string(forKey: "userLoginAPPID")!){
                (result) in
                switch result{
                case .success(let userGetProfile):
                    self.userConGetProfile = userGetProfile
                    self.showProfileView = true
                case .failure( _):
                    break
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(usertokenID: "", userID: "", userConGetProfile: UGProfileDec(id: "", status: "", created: "", lastLogin: "", profile: ProfileUG(firstName: "", lastName: "", email: "", login: "", birthday: "", profileUrl: "")))
    }
}




