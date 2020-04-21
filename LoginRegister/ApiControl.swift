//
//  ApiControl.swift
//  LoginRegister
//
//  Created by Joker on 2020/4/15.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ApiControl{
    static let shared = ApiControl()
    
    func GetAllUserAPI(UserName:String, UserEmail:String, completion: @escaping((Result<String, NetworkError>) -> Void)) {
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users?limit=200")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try?decoder.decode([AllUserDec].self, from: retData), dic[0].status != ""{
                for i in 0...dic.count - 1 {
                    if dic[i].profile.login == UserName && dic[i].profile.email == UserEmail{
                        completion(.success(dic[i].id))
                        print("Get ID:" + dic[i].id)
                        break
                    }
                    else{
                        completion(.failure(NetworkError.Error))
                    }
                }
            }else{
                completion(.failure(NetworkError.Error))
                //print(String(data: retData!, encoding: .utf8))
            }
        }.resume()
    }
    
    func LoginAPI(LoginUserName:String, LoginPassWord:String, completion: @escaping((Result<LoginDec, NetworkError>) -> Void)){
        let url = URL(string: "https://dev-976098.okta.com/api/v1/authn")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        struct Login: Encodable {
            var username:String
            var password:String
        }
        var userLogin = Login(username: LoginUserName, password: LoginPassWord)
        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(userLogin){
            urlRequest.httpBody = data
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try?decoder.decode(LoginDec.self, from: retData), dic.status == "SUCCESS"{
                    completion(.success(dic))
                }else{
                    completion(.failure(NetworkError.Error))
                    //print(String(data: retData!, encoding: .utf8))
                }
            }.resume()
        }
    }
    
    func RegisterAPI(Rfirstname:String, Rlastname:String, Remail:String, Rlogin:String, Rbirthday:String, Rprofilurl:String, Rpassword:String, completion:@escaping((Result<RegisterDec, RegisterError>) -> Void)){
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users?activate=true")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        struct Register: Encodable {
            var profile: ProfileR
            var credentials: Credentials
        }
        var userProfile = ProfileR(firstName: Rfirstname, lastName: Rlastname, email: Remail, login: Rlogin, birthday: Rbirthday, profileUrl: Rprofilurl)
        var userPassword = Password(value: Rpassword)
        var userCredentials = Credentials(password: userPassword)
        var userRegister = Register(profile: userProfile, credentials: userCredentials)
        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(userRegister){
            urlRequest.httpBody = data
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try?decoder.decode(RegisterDec.self, from: retData), dic.status == "ACTIVE"{
                    completion(.success(dic))
                }else{
                    completion(.failure(RegisterError.Err))
                    //print(String(data: retData!, encoding: .utf8))
                }
            }.resume()
        }
    }
    
    func ChangeRecoveryQuestionAPI(UserID:String, UserPassword:String, UserRQ:String, UserRA:String, completion:@escaping((Result<String, NetworkError>) -> Void)){
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users/" + UserID + "/credentials/change_recovery_question")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        struct CRQ: Encodable{
            var password:Password
            var recovery_question: Recovery_Q
        }
        var userRecovery_Q = Recovery_Q(question: UserRQ, answer: UserRA)
        var userPassword = Password(value: UserPassword)
        var userCRQ = CRQ(password: userPassword, recovery_question: userRecovery_Q)
        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(userCRQ){
            urlRequest.httpBody = data
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try?decoder.decode(CRQDec.self, from: retData), dic.provider.type == "OKTA"{
                    completion(.success(dic.provider.type))
                }else{
                    completion(.failure(NetworkError.Error))
                    //print(String(data: retData!, encoding: .utf8))
                }
            }.resume()
        }
        
    }
    
    func GetProfileAPI(UserID:String, completion:@escaping((Result<UGProfileDec, GetProfileError>) -> Void)){
        let url = URL(string:"https://dev-976098.okta.com/api/v1/users/" + UserID)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try?decoder.decode(UGProfileDec.self, from: retData), dic.status != ""{
                completion(.success(dic))
            }else{
                completion(.failure(GetProfileError.GPErr))
                //print(String(data: retData!, encoding: .utf8))
            }
        }.resume()
    }
    
    func ModifyProfileAPI(userID: String, Mfirstname:String?, Mlastname:String?, Mprofileurl:String?, Mbirthday: String?, completion:@escaping((Result<UGProfileDec, NetworkError>)) -> Void){
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users/" + userID)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        struct Modify: Encodable {
            var profile: MProfile
        }
        var userMProfile = MProfile(firstName: Mfirstname, lastName: Mlastname, birthday: Mbirthday, profileUrl: Mprofileurl)
        var userModify = Modify(profile: userMProfile)
        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(userModify){
            urlRequest.httpBody = data
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try?decoder.decode(UGProfileDec.self, from: retData), dic.status == "ACTIVE"{
                    completion(.success(dic))
                }else{
                    completion(.failure(NetworkError.Error))
                    //print(String(data: retData!, encoding: .utf8))
                }
            }.resume()
        }
    }
    
    func ModifyPasswordAPI(userID:String, oldPassword:String, newPassword:String, completion:@escaping((Result<MPDDec, NetworkError>)) -> Void) {
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users/" + userID + "/credentials/change_password")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        struct MPD: Encodable{
            var oldPassword:OPD
            var newPassword:NPD
        }
        var userOPD = OPD(value: oldPassword)
        var userNPD = NPD(value: newPassword)
        var userMPD = MPD(oldPassword: userOPD, newPassword: userNPD)
        
        let jsonEncoder = JSONEncoder()
        if let data = try? jsonEncoder.encode(userMPD){
            urlRequest.httpBody = data
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                let decoder = JSONDecoder()
                if let retData = retData, let dic = try?decoder.decode(MPDDec.self, from: retData), dic.provider.type == "OKTA"{
                    completion(.success(dic))
                }else{
                    completion(.failure(NetworkError.Error))
                    //print(String(data: retData!, encoding: .utf8))
                }
            }.resume()
        }
    }
    
    func ForgetPasswordAPI(UserID: String, completion:@escaping((Result<String, NetworkError>) -> Void)){
        let url = URL(string: "https://dev-976098.okta.com/api/v1/users/" + UserID + "/credentials/forgot_password?sendEmail=false")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("SSWS 00Nv7lHk73t3tqrNP2d593tEshKK0kXWyHTLCTpc4u", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try?decoder.decode(FPDec.self, from: retData), dic.resetPasswordUrl != ""{
                completion(.success(dic.resetPasswordUrl))
            }else{
                completion(.failure(NetworkError.Error))
                //print(String(data: retData!, encoding: .utf8))
            }
        }.resume()
        
    }
    
    func uploadImage(uiImage: UIImage, completion:@escaping((Result<String, GetPhotoURLError>) -> Void)){
        let headers: HTTPHeaders = [
            "Authorization": "Client-ID f5a20294a5237b3",
        ]
        AF.upload(multipartFormData: { (data) in
            let imageData = uiImage.jpegData(compressionQuality: 0.9)
            data.append(imageData!, withName: "image")
        }, to: "https://api.imgur.com/3/upload", headers: headers).responseDecodable(of: UploadImageResult.self, queue: .main, decoder: JSONDecoder()){(response) in
            switch response.result {
            case .success(let result):
                completion(.success(result.data.link))
                print(result.data.link)
            case .failure(let error):
                completion(.failure(GetPhotoURLError.GPUErr))
                print(error)
            }
        }
    }
    
    //氣象局開放資料
    func GetWeatherToday(locationName: String, completion:@escaping((Result<WeatherDec, NetworkError>) -> Void)){
        let url = URL(string: "https://opendata.cwb.gov.tw/fileapi/v1/opendataapi/O-A0003-001?Authorization=rdec-key-123-45678-011121314&format=JSON")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try?decoder.decode(WeatherDec.self, from: retData), dic.cwbopendata.status == "Actual"{
                completion(.success(dic))
            }else{
                completion(.failure(NetworkError.Error))
                //print(String(data: retData!, encoding: .utf8))
            }
        }.resume()
    }
    
    //63數據中心-查詢星座今日運勢API
    func GetConstelllationToday(ConID: String, completion:@escaping((Result<ConDec, NetworkError>) -> Void)){
        let url = URL(string: "http://api.63code.com/fortune_today/api.php?fortune=" + ConID)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"

        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try?decoder.decode(ConDec.self, from: retData), dic.code == "1"{
                completion(.success(dic))
            }else{
                completion(.failure(NetworkError.Error))
                //print(String(data: retData!, encoding: .utf8))
            }
        }.resume()
    }
    
    //繁化姬API 轉化簡體.大陸用語
    //converter=Taiwan 大陸轉台灣用語(BETA)
    //converter=Traditional 單純簡體轉繁體
    func Traditional(TString: String, completion:@escaping((Result<String, NetworkError>) -> Void)) {
        let chineseurl = String("https://api.zhconvert.org/convert?converter=Traditional&text=" + TString)
        let url = URL(string: chineseurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        //print(url)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest) { (retData, res, err) in
            let decoder = JSONDecoder()
            if let retData = retData, let dic = try?decoder.decode(TraditionalDec.self, from: retData), dic.code == 0{
                completion(.success(dic.data.text))
                //print(dic.data.text)
            }else{
                completion(.failure(NetworkError.Error))
                //print(String(data: retData!, encoding: .utf8))
            }
        }.resume()
        
    }
    
    func ConstellationJudge(Month: String, Day: String) -> String{
        let MonthInt = Int(Month)
        let DayInt = Int(Day)
        
        if MonthInt == 4 && DayInt! < 20{
            return "牡羊座1"
        }
        if MonthInt == 3 && DayInt! > 20{
            return "牡羊座1"
        }
        if MonthInt == 5 && DayInt! < 21{
            return "金牛座2"
        }
        if MonthInt == 4 && DayInt! > 19{
            return "金牛座2"
        }
        if MonthInt == 6 && DayInt! < 22{
            return "雙子座3"
        }
        if MonthInt == 5 && DayInt! > 20{
            return "雙子座3"
        }
        if MonthInt == 7 && DayInt! < 23{
            return "巨蟹座4"
        }
        if MonthInt == 6 && DayInt! > 21{
            return "巨蟹座4"
        }
        if MonthInt == 8 && DayInt! < 23{
            return "獅子座5"
        }
        if MonthInt == 7 && DayInt! > 22{
            return "獅子座5"
        }
        if MonthInt == 9 && DayInt! < 23{
            return "處女座6"
        }
        if MonthInt == 8 && DayInt! > 22{
            return "處女座6"
        }
        if MonthInt == 10 && DayInt! < 24{
            return "天秤座7"
        }
        if MonthInt == 9 && DayInt! > 22{
            return "天秤座7"
        }
        if MonthInt == 11 && DayInt! < 23{
            return "天蠍座8"
        }
        if MonthInt == 10 && DayInt! > 23{
            return "天蠍座8"
        }
        if MonthInt == 12 && DayInt! < 22{
            return "射手座9"
        }
        if MonthInt == 11 && DayInt! > 22{
            return "射手座9"
        }
        if MonthInt == 1 && DayInt! < 20{
            return "摩羯座10"
        }
        if MonthInt == 12 && DayInt! > 21{
            return "摩羯座10"
        }
        if MonthInt == 2 && DayInt! < 19{
            return "水瓶座11"
        }
        if MonthInt == 1 && DayInt! > 19{
            return "水瓶座11"
        }
        if MonthInt == 3 && DayInt! < 21{
            return "雙魚座12"
        }
        if MonthInt == 2 && DayInt! > 18{
            return "雙魚座12"
        }
        return "可憐"
    }
    
}


