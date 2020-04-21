//
//  ProfileView.swift
//  LoginRegister
//
//  Created by Joker on 2020/4/17.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import SwiftUI
import URLImage

struct ProfileView: View {
    @State var userGetProfile:UGProfileDec
    @State private var showProfileModify = false
    @State private var showPasswordModify = false
    @State private var getConData = ""
    @State private var getConlucky_color = ""
    @State private var getConlucky_numbers = ""
    @State private var getConmatch_con = ""
    @State private var getConcomprehensive_luck = ""
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack{
            List{
                if self.userGetProfile.profile.profileUrl != ""{
                    URLImage(URL(string: self.userGetProfile.profile.profileUrl)!){ proxy in
                        proxy.image
                            .resizable()
                            .scaledToFill()
                            .frame(width:300, height: 300)
                            .cornerRadius(.infinity)
                            .shadow(radius: 30)
                            .modifier(CenterModifier())
                    }
                    .padding(.bottom, 70)
                }
                else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width:300, height: 300)
                        .cornerRadius(.infinity)
                        .shadow(radius: 30)
                        .modifier(CenterModifier())
                        .foregroundColor(.gray)
                }
                
                Button(action:{
                    ApiControl.shared.GetProfileAPI(UserID: self.userGetProfile.id){
                        (result) in
                        switch result{
                        case .success(let userGetProfile):
                            self.userGetProfile = userGetProfile
                        case .failure( _):
                            break
                        }
                    }
                }){
                    HStack{
                        Image(systemName: "arrow.counterclockwise")
                            .frame(width: 30)
                        Text("重新整理")
                            .font(.system(size: 20))
                    }.foregroundColor(Color(red: 195/255, green: 233/255, blue: 233/255))
                }
                
                Button(action:{
                    userDefaults.set("unknown", forKey: "userLoginAPPID")
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    HStack{
                        Image(systemName: "power")
                            .frame(width: 30)
                        Text("登出")
                            .font(.system(size: 20))
                    }.foregroundColor(Color(red: 195/255, green: 233/255, blue: 233/255))
                }
                .padding(.bottom, 20)
                Group{
                    HStack{
                        Image(systemName: "person.crop.circle.badge.plus")
                            .frame(width:30)
                        Text("帳號：" + self.userGetProfile.profile.login)
                    }
                    HStack{
                        Image(systemName: "person.crop.circle")
                            .frame(width:30)
                        Text("姓名：" + self.userGetProfile.profile.firstName + " " + self.userGetProfile.profile.lastName)
                    }
                    HStack{
                        Image(systemName: "calendar")
                            .frame(width:30)
                        Text("生日：" + self.userGetProfile.profile.birthday)
                    }
                    HStack{
                        Image(systemName: "star")
                            .frame(width:30)
                        Text("星座：" + ApiControl.shared.ConstellationJudge(Month: String(self.userGetProfile.profile.birthday.suffix(4).dropLast(2)), Day: String(self.userGetProfile.profile.birthday.suffix(4).dropFirst(2))).prefix(3))
                    }
                    HStack{
                        Image(systemName: "envelope")
                            .frame(width:30)
                        Text("電子信箱：" + self.userGetProfile.profile.email)
                    }.padding(.bottom, 80)
                        .padding(.top, 3)
                    Group{
                        
                        Text("關於你的星座")
                            .font(.system(size:50))
                        Text(ApiControl.shared.ConstellationJudge(Month: String(self.userGetProfile.profile.birthday.suffix(4).dropLast(2)), Day: String(self.userGetProfile.profile.birthday.suffix(4).dropFirst(2))).prefix(3))
                            .font(.system(size: 60))
                            .padding(.bottom, 20)
                        Text(AstroInfo(Astro: String(ApiControl.shared.ConstellationJudge(Month: String(self.userGetProfile.profile.birthday.suffix(4).dropLast(2)), Day: String(self.userGetProfile.profile.birthday.suffix(4).dropFirst(2))).prefix(3))))
                            .padding(.bottom, 90)
                        VStack(alignment: .leading){
                            Text("今日的")
                                .font(.system(size:50))
                            Text(ApiControl.shared.ConstellationJudge(Month: String(self.userGetProfile.profile.birthday.suffix(4).dropLast(2)), Day: String(self.userGetProfile.profile.birthday.suffix(4).dropFirst(2))).prefix(3))
                                .font(.system(size: 60))
                                .padding(.bottom, 20)
                        }
                        HStack{
                            Image(systemName: "number")
                                .frame(width:30)
                            Text("幸運數字：" + self.getConlucky_numbers)
                        }
                        HStack{
                            Image(systemName: "paintbrush")
                                .frame(width:30)
                            Text("幸運顏色：" + self.getConlucky_color)
                        }
                        HStack{
                            Image(systemName: "heart")
                                .frame(width:30)
                            Text("速配星座：" + self.getConmatch_con)
                        }
                        HStack{
                            Image(systemName: "list.dash")
                                .frame(width:30)
                            Text("整體運勢：")
                        }
                        Text(self.getConcomprehensive_luck)
                        HStack{
                            Image(systemName: "clock")
                                .frame(width:30)
                            Text("更新時間：" + self.getConData)
                        }.padding(.bottom, 80)
                    }
                }.font(.system(size: 23))
                    .foregroundColor(Color(red: 195/255, green: 233/255, blue: 233/255))
                Group{
                    if self.userGetProfile.status == "ACTIVE"{
                        Text("帳號狀態：已驗證")
                    }
                    else{
                        Text("帳號狀態：未驗證")
                    }
                    Text("上次登入時間：" + self.userGetProfile.lastLogin.prefix(10))
                    Text("帳號創立時間：" +  self.userGetProfile.created.prefix(10))
                    Text("帳號ID：" + self.userGetProfile.id)
                        .padding(.bottom, 30)
                        .padding(.top, 5)
                }.font(.system(size:18))
                    .foregroundColor(Color(red: 195/255, green: 233/255, blue: 233/255))
            }.onAppear{
                UITableView.appearance().separatorColor = .clear
                UITableView.appearance().backgroundColor = .clear
                UITableViewCell.appearance().backgroundColor = .clear
                userDefaults.set(self.userGetProfile.id, forKey: "userLoginAPPID")
                ApiControl.shared.GetConstelllationToday(ConID:String(ApiControl.shared.ConstellationJudge(Month: String(self.userGetProfile.profile.birthday.suffix(4).dropLast(2)), Day: String(self.userGetProfile.profile.birthday.suffix(4).dropFirst(2))).dropFirst(3))){
                    (result) in
                    switch result {
                    case .success(let ConDec):
                        self.getConData = ConDec.data
                        self.getConlucky_numbers = ConDec.lucky_numbers
                        ApiControl.shared.Traditional(TString: ConDec.lucky_color){
                            (result) in
                            switch result{
                            case .success(let TString):
                                self.getConlucky_color = TString
                            case .failure( _):
                                print("Connot get the Tradition!!")
                            }
                        }
                        ApiControl.shared.Traditional(TString: ConDec.match_constellation){
                            (result) in
                            switch result{
                            case .success(let TString):
                                self.getConmatch_con = TString
                            case .failure( _):
                                print("Connot get the Tradition!!")
                            }
                        }
                        ApiControl.shared.Traditional(TString: ConDec.comprehensive_luck){
                            (result) in
                            switch result{
                            case .success(let TTString):
                                self.getConcomprehensive_luck = TTString
                            case .failure( _):
                                print("Connot get the Tradition!!")
                            }
                        }
                    case .failure( _):
                        print("Cannot get the ConData!!")
                    }
                }
            }
            .background(Image("Background"))
            .navigationBarBackButtonHidden(true)
            
            Button("修改個人資料"){
                self.showProfileModify = true
            }.font(.system(size: 30))
                .frame(width:310)
                .padding(.all, 10)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red:91/255,green:191/255,blue:236/255), Color(red:250/255,green:191/255,blue:221/255)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15)
                .padding(.bottom, 10)
                .sheet(isPresented: $showProfileModify){ProfileModify(userID: self.userGetProfile.id)}
            Button("修改密碼"){
                self.showPasswordModify = true
            }.font(.system(size: 30))
                .frame(width:310)
                .padding(.all, 10)
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red:91/255,green:191/255,blue:236/255), Color(red:250/255,green:191/255,blue:221/255)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15)
                .sheet(isPresented: $showPasswordModify){
                    PasswordModify(userID: self.userGetProfile.id)}
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(userGetProfile: UGProfileDec(id: "XXX", status: "XXX", created: "XXX", lastLogin: "XXX", profile: ProfileUG(firstName: "XXX", lastName: "XXX", email: "XXX", login: "XXX", birthday: "19990309", profileUrl: "https://i.imgur.com/rlBzghZ.jpeg")))
    }
}

struct CenterModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}

func AstroInfo(Astro: String) -> String{
    if Astro == "摩羯座"{
        return "魔羯座又稱為摩羯座或山羊座，主宰星是「土星」，英文是 Capricorn，星座符號是 ♑，守護神是農神「薩圖爾努斯」。魔羯座個性具有堅毅的耐力，務實的態度，作事一步一腳印，個性嚴謹、守紀律，但受土星的影響，有時會表現出冷漠、憂鬱、悲觀、壓抑、欠缺浪漫與不易溝通的特質"
    }
    if Astro == "金牛座"{
        return "金牛座主宰星為「金星」，英文是 Taurus，星座符號是 ♉，守護神為職司愛與美的女神「維納斯」。金牛個性趨於保守、務實且傳統。生活較重視物質層面，做事刻苦耐勞，耐力過人。不過有時會給人固執不知變通、做事刻板的感覺，甚至可能有物慾的傾象。"
    }
    if Astro == "處女座"{
        return "處女座主宰星為「水星」，英文是 Virgo，星座符號是 ♍，守護神為職司智慧與正義女神「雅典娜」。處女座個性善於分析整理、識人之明、個性細膩，並追求完美，但當面對無法解構渾沌無規則可循的事物時，常顯現神經質與嘮叨不休的個性。"
    }
    if Astro == "牡羊座"{
        return "牡羊座又稱為白羊座，英文是 Aries，星座符號是 ♈，主宰星為「火星」，守護神為戰神「瑪爾斯」。牡羊座個性急切，做事講求效率，行動力十足，說做就做，創造性佳，但有時做事三分鐘熱度、缺乏耐性，且過於衝動，容易讓人產生欠缺思慮的不良印象。"
    }
    if Astro == "獅子座"{
        return "獅子座主宰星為「太陽」，英文是 Leo，星座符號是 ♌，守護神為光明之神「阿波羅」。獅子座個性較為自我，喜愛成為團體的中心或焦點，自尊心強烈，具有領導潛能與優越感。但倘若獅子座無法成為眾人的焦點，為了吸引它人目光，有時容易過度表現、行為誇張。"
    }
    if Astro == "射手座"{
        return "射手座又稱為人馬座，主宰星是「木星」，英文是 Sagittarius，星座符號是 ♐，守護神則是全能的「宙斯」。射手座個性喜愛思考探索與追尋哲理，個性樂觀，富理想，好自由，但有時常粗心大意，一副無所謂的樣子，令人感到沒有責任感，甚至有時會有過度樂觀的傾向。"
    }
    if Astro == "天秤座"{
        return "天秤座主宰星為「金星」，英文是 Libra，星座符號是 ♎，守護神為職司智慧與正義的女神「雅典娜」與愛情女神「維納斯」。天秤座個性對任何事物抱持著平衡的態度，性格著重公平客觀，對藝術有良好鑑賞力，但有時為取得平衡，容易表現出優柔寡斷的負面形象。"
    }
    if Astro == "水瓶座"{
        return "水瓶座又稱為寶瓶座，主宰星為「土星(古典)、天王星(現代)」，英文是 Aquarius，星座符號是 ♒，守護神為天神「烏拉諾斯」。水瓶座個性喜歡在周遭觀察眾生百態，個性獨立且自主，富有創意與研究精神，但有時因想法標新立異、顛覆傳統，不容易與人群融合，會給人一種獨行俠或不合群的印象。"
    }
    if Astro == "雙子座"{
        return "雙子座主宰星為「水星」，英文是 Gemini，星座符號是 ♊，守護神為傳遞知識訊息的「墨丘利」。雙子座個性具洞悉情勢、善於溝通、機智過人、應變能力強的特質。但雙子有時會過於善變，讓人捉摸不定的感覺，做事不夠專注，喜愛談論八卦，因此容易給人浮誇不實，甚至膚淺的印象。"
    }
    if Astro == "巨蟹座"{
        return "巨蟹座主宰星為「月亮」，英文是 Cancer，星座符號是 ♋，守護神為狩獵女神「黛安娜」。巨蟹座個性偏好在固定範疇內行事以求得保護與安全感，常是家庭的守護者，個性較念舊敏銳，家庭意識深厚，若無法受到保護與慰藉時，容易產生排外性、防衛心、退縮閉塞的特質。"
    }
    if Astro == "天蠍座"{
        return "天蠍座主宰星為「火星(古典)、冥王星(現代)」，英文是 Scorpio，星座符號是 ♏，守護神為統治地獄的「普路托」。天蠍座個性善於守密，個性沈穩，意志力堅強，深謀遠慮，但受冥王星的陰險特質影響，天蠍座也很容易多疑，善妒，佔有慾強，報復心重，甚至有時會有縱慾的傾向。"
    }
    if Astro == "雙魚座"{
        return "雙魚座的守護星為「木星(古典)、海王星(現代)」，英文是 Pisces，星座符號是 ♓，守護神為「海神 (Poseidon)」。雙魚座個性包容力強，富有直覺，悲天憫人，容易與人相處，但有時為求凡事融洽，作事缺乏原則，容易受騙上當，甚至有時會有自我催眠或自我欺騙的負面傾向。"
    }
    return ""
}

