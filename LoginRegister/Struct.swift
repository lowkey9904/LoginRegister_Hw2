//
//  Struct.swift
//  LoginRegister
//
//  Created by Joker on 2020/4/15.
//  Copyright © 2020 ntoucs. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case Error
}

enum RegisterError: Error {
    case Err
}

enum GetProfileError: Error {
    case GPErr
}

enum GetPhotoURLError: Error {
    case GPUErr
}

struct Profile: Codable{
    var login:String
    var firstName:String
    var lastName:String
}

struct User: Codable{
    var id:String
    var profile: Profile
}

struct Embedded: Codable{
    var user:User
}

struct LoginDec: Codable {
    var status:String
    var sessionToken:String
    var _embedded: Embedded
}

struct ProfileR: Codable{
    var firstName:String
    var lastName:String
    var email:String
    var login:String
    var birthday:String
    var profileUrl:String
}

struct Password: Encodable {
    var value:String
}

struct Credentials: Encodable{
    var password: Password
}

struct RegisterDec: Codable {
    var status:String
    var id:String
    var profile:ProfileR
}

struct ProfileUG: Codable {
    var firstName:String
    var lastName:String
    var email:String
    var login:String
    var birthday:String
    var profileUrl:String
}

struct UGProfileDec: Codable{
    var id:String
    var status:String
    var created:String
    var lastLogin:String
    var profile:ProfileUG
}

struct UploadImageResult: Decodable {
    struct Data: Decodable {
        let link: String
    }
    let data: Data
}

struct MProfile: Codable{
    var firstName:String?
    var lastName:String?
    var birthday:String?
    var profileUrl:String?
}

struct OPD: Codable {
    var value:String
}

struct NPD: Codable {
    var value:String
}

struct Provider: Codable {
    var type:String
    var name:String
}

struct MPDDec: Codable {
    var provider:Provider
}

struct value: Codable {
    var value:String
}

struct WET: Codable {
    var elementName:String
    var elementValue:value
}

struct Loc: Codable {
    var locationName:String
    var weatherElement:[WET]
}

struct Cwbopendata: Codable {
    var sent:String //sent time
    var status:String
    var location:[Loc]
}

struct WeatherDec: Codable {
    var cwbopendata:Cwbopendata
}

struct FindLoginProfile: Codable {
    var login:String
    var email:String
}

struct AllUserDec: Codable {
    var id:String
    var status:String
    var profile:FindLoginProfile
}

struct Recovery_Q: Codable {
    var question:String
    var answer:String
}

struct CRQDec: Codable {
    var provider:Provider
}

struct FPDec: Codable {
    var resetPasswordUrl:String
}

struct ConDec: Codable {
    var code:String //狀態碼（為1則為成功，為404則查詢失敗）
    var data:String //日期（解析成功返回的當天日期）
    var lucky_color:String
    var lucky_numbers:String
    var match_constellation:String //速配星座（解析成功返回的指定星座當日速配星座）
    var comprehensive_luck:String //綜合運勢（解析成功返回的指定星座當日綜合運勢）
}

struct TData: Codable {
    var text:String //回傳的翻譯字串
}

struct TraditionalDec: Codable {
    var code:Int //0為成功
    var data:TData
}
