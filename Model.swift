//
//  Model.swift
//  QuickLearn
//
//  Created by Xtreem Solution on 25/02/19.
//  Copyright © 2019 XtreemSolution. All rights reserved.
//

import Foundation

 class UserLoginData {
    static let shared = UserLoginData()
    var id : String!
    var name : String!
    var username : String!
    var email : String!
    var contact_number : String!
    var token : String!
    var picture_url : String!
    var available_balance : String!
    
    func setData(json: [String : Any]) {
        if let userId = json["id"] as? String {
            UserLoginData.shared.id = userId
        }
        if let name = json["name"] as? String {
            UserLoginData.shared.name = name
        }
        if let userName = json["username"] as? String {
            UserLoginData.shared.username = userName
        }
        if let userEmail = json["email"] as? String {
            UserLoginData.shared.email = userEmail
        }
        if let contactNumber = json["contact_number"] as? String {
            UserLoginData.shared.contact_number = contactNumber
        }
        if let deviceToken = json["token"] as? String {
            UserLoginData.shared.token = deviceToken
        }
        if let picture_url = json["picture_url"] as? String {
            UserLoginData.shared.picture_url = picture_url
        }
        if let available_balance = json["available_balance"] as? String {
            UserLoginData.shared.available_balance = available_balance
        }
    }
    
    func updateProfile(json: [String : Any]) {
        if let userId = json["id"] as? String {
            UserLoginData.shared.id = userId
        }
        if let name = json["name"] as? String {
            UserLoginData.shared.name = name
        }
        if let userName = json["username"] as? String {
            UserLoginData.shared.username = userName
        }
        if let userEmail = json["email"] as? String {
            UserLoginData.shared.email = userEmail
        }
        if let contactNumber = json["contact_number"] as? String {
            UserLoginData.shared.contact_number = contactNumber
        }
        if let deviceToken = json["token"] as? String {
            UserLoginData.shared.token = deviceToken
        }
        if let picture_url = json["picture_url"] as? String {
            UserLoginData.shared.picture_url = picture_url
        }
        if let available_balance = json["available_balance"] as? String {
            UserLoginData.shared.available_balance = available_balance
        }
    }
}

class MyProfileDetails {
    
    static let shared = MyProfileDetails()
    
    var id : String!
    var name : String!
    var username : String!
    var email : String!
    var contact_number : String!
    var study_type : String!
    var school_id : String!
    var university_id : String!
    var year : String!
    var hourly_rate : String!
    var password : String!
    var set_password_key : String!
    var is_admin : String!
    var is_registered : String!
    var user_type : String!
    var profile_image : String!
    var is_email_verified : String!
    var token : String!
    var device_token : String!
    var device_type : String!
    var status : String!
    var add_date : String!
    var forgot_password_key : String!
    var expire_time : String!
    var email_verified_key : String!
    var update_date : String!
    var education_name : String!
    var avg_rating : String!
    
    var subject_detail : [[String:Any]] = []

    
    func setProfileData(json: [String : Any]) {
        if let userId = json["id"] as? String {
            MyProfileDetails.shared.id = userId
        }
        if let name = json["name"] as? String {
            MyProfileDetails.shared.name = name
        }
        if let userName = json["username"] as? String {
            MyProfileDetails.shared.username = userName
        }
        if let userEmail = json["email"] as? String {
            MyProfileDetails.shared.email = userEmail
        }
        if let contactNumber = json["contact_number"] as? String {
            MyProfileDetails.shared.contact_number = contactNumber
        }
        if let study_type = json["study_type"] as? String {
            MyProfileDetails.shared.study_type = study_type
        }
        if let school_id = json["school_id"] as? String {
            MyProfileDetails.shared.school_id = school_id
        }
        if let university_id = json["university_id"] as? String {
            MyProfileDetails.shared.university_id = university_id
        }
        if let year = json["year"] as? String {
            MyProfileDetails.shared.year = year
        }
        if let hourly_rate = json["hourly_rate"] as? String {
            MyProfileDetails.shared.hourly_rate = hourly_rate
        }
        if let password = json["password"] as? String {
            MyProfileDetails.shared.password = password
        }
        if let set_password_key = json["set_password_key"] as? String {
            MyProfileDetails.shared.set_password_key = set_password_key
        }
        if let is_admin = json["is_admin"] as? String {
            MyProfileDetails.shared.is_admin = is_admin
        }
        if let is_registered = json["is_registered"] as? String {
            MyProfileDetails.shared.is_registered = is_registered
        }
        if let user_type = json["user_type"] as? String {
            MyProfileDetails.shared.user_type = user_type
        }
        if let profile_image = json["profile_image"] as? String {
            MyProfileDetails.shared.profile_image = profile_image
        }
        if let is_email_verified = json["is_email_verified"] as? String {
            MyProfileDetails.shared.is_email_verified = is_email_verified
        }
        if let token = json["token"] as? String {
            MyProfileDetails.shared.token = token
        }
        
        if let device_token = json["device_token"] as? String {
            MyProfileDetails.shared.device_token = device_token
        }
        if let device_type = json["device_type"] as? String {
            MyProfileDetails.shared.device_type = device_type
        }
        if let status = json["status"] as? String {
            MyProfileDetails.shared.status = status
        }
        if let add_date = json["add_date"] as? String {
            MyProfileDetails.shared.add_date = add_date
        }
        if let forgot_password_key = json["forgot_password_key"] as? String {
            MyProfileDetails.shared.forgot_password_key = forgot_password_key
        }
        if let expire_time = json["expire_time"] as? String {
            MyProfileDetails.shared.expire_time = expire_time
        }
        if let email_verified_key = json["email_verified_key"] as? String {
            MyProfileDetails.shared.email_verified_key = email_verified_key
        }
        if let update_date = json["update_date"] as? String {
            MyProfileDetails.shared.update_date = update_date
        }
        if let education_name = json["education_name"] as? String {
            MyProfileDetails.shared.education_name = education_name
        }
        if let avg_rating = json["avg_rating"] as? String {
            MyProfileDetails.shared.avg_rating = avg_rating
        }
        if let subject_detail = json["subject_detail"]  {
            MyProfileDetails.shared.subject_detail = subject_detail as! [[String : Any]]
        }
    }
    
    func updateProfileData(json: [String : Any]) {
        if let userId = json["id"] as? String {
            MyProfileDetails.shared.id = userId
        }
        if let name = json["name"] as? String {
            MyProfileDetails.shared.name = name
        }
        if let userName = json["username"] as? String {
            MyProfileDetails.shared.username = userName
        }
        if let userEmail = json["email"] as? String {
            MyProfileDetails.shared.email = userEmail
        }
        if let contactNumber = json["contact_number"] as? String {
            MyProfileDetails.shared.contact_number = contactNumber
        }
        if let study_type = json["study_type"] as? String {
            MyProfileDetails.shared.study_type = study_type
        }
        if let school_id = json["school_id"] as? String {
            MyProfileDetails.shared.school_id = school_id
        }
        if let university_id = json["university_id"] as? String {
            MyProfileDetails.shared.university_id = university_id
        }
        if let year = json["year"] as? String {
            MyProfileDetails.shared.year = year
        }
        if let hourly_rate = json["hourly_rate"] as? String {
            MyProfileDetails.shared.hourly_rate = hourly_rate
        }
        if let password = json["password"] as? String {
            MyProfileDetails.shared.password = password
        }
        if let set_password_key = json["set_password_key"] as? String {
            MyProfileDetails.shared.set_password_key = set_password_key
        }
        if let is_admin = json["is_admin"] as? String {
            MyProfileDetails.shared.is_admin = is_admin
        }
        if let is_registered = json["is_registered"] as? String {
            MyProfileDetails.shared.is_registered = is_registered
        }
        if let user_type = json["user_type"] as? String {
            MyProfileDetails.shared.user_type = user_type
        }
        if let profile_image = json["profile_image"] as? String {
            MyProfileDetails.shared.profile_image = profile_image
        }
        if let is_email_verified = json["is_email_verified"] as? String {
            MyProfileDetails.shared.is_email_verified = is_email_verified
        }
        if let token = json["token"] as? String {
            MyProfileDetails.shared.token = token
        }
        
        if let device_token = json["device_token"] as? String {
            MyProfileDetails.shared.device_token = device_token
        }
        if let device_type = json["device_type"] as? String {
            MyProfileDetails.shared.device_type = device_type
        }
        if let status = json["status"] as? String {
            MyProfileDetails.shared.status = status
        }
        if let add_date = json["add_date"] as? String {
            MyProfileDetails.shared.add_date = add_date
        }
        if let forgot_password_key = json["forgot_password_key"] as? String {
            MyProfileDetails.shared.forgot_password_key = forgot_password_key
        }
        if let expire_time = json["expire_time"] as? String {
            MyProfileDetails.shared.expire_time = expire_time
        }
        if let email_verified_key = json["email_verified_key"] as? String {
            MyProfileDetails.shared.email_verified_key = email_verified_key
        }
        if let update_date = json["update_date"] as? String {
            MyProfileDetails.shared.update_date = update_date
        }
        if let education_name = json["education_name"] as? String {
            MyProfileDetails.shared.education_name = education_name
        }
        if let avg_rating = json["avg_rating"] as? String {
            MyProfileDetails.shared.avg_rating = avg_rating
        }
        if let subject_detail = json["subject_detail"]  {
            MyProfileDetails.shared.subject_detail = subject_detail as! [[String : Any]]
        }

    }
}

class SchoolSubjectList {
    var id : String!
    var status : String!
    var add_date : String!
    var name : String!
    var update_date : String!
    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        self.id = parseData["id"].stringValue
        self.status = parseData["status"].stringValue
        self.add_date = parseData["add_date"].stringValue
        self.name = parseData["name"].stringValue
        self.update_date = parseData["update_date"].stringValue
    }
}

class SchoolNameList {
    var id : String!
    var status : String!
    var add_date : String!
    var name : String!
    var update_date : String!
    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        self.id = parseData["id"].stringValue
        self.status = parseData["status"].stringValue
        self.add_date = parseData["add_date"].stringValue
        self.name = parseData["name"].stringValue
        self.update_date = parseData["update_date"].stringValue
    }
}

class UniversityNameList {
    var id : String!
    var status : String!
    var add_date : String!
    var name : String!
    var update_date : String!
    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        self.id = parseData["id"].stringValue
        self.status = parseData["status"].stringValue
        self.add_date = parseData["add_date"].stringValue
        self.name = parseData["name"].stringValue
        self.update_date = parseData["update_date"].stringValue
    }
}

class SubjectDetails {
    static let shared = SubjectDetails()
    var id : String!
    var user_id : String!
    var subject_id : String!
    var grade : String!
    var add_date : String!
    var name : String!
    
    func setData(json: [String : Any]) {
        if let userId = json["id"] as? String {
            UserLoginData.shared.id = userId
        }
        if let user_id = json["user_id"] as? String {
            SubjectDetails.shared.user_id = user_id
        }
        if let subject_id = json["subject_id"] as? String {
            SubjectDetails.shared.subject_id = subject_id
        }
        if let grade = json["grade"] as? String {
            SubjectDetails.shared.grade = grade
        }
        if let add_date = json["add_date"] as? String {
            SubjectDetails.shared.add_date = add_date
        }
        if let subjectName = json["name"] as? String {
            SubjectDetails.shared.name = subjectName
        }
    }
    
    func updateSubject(json: [String : Any]) {
        if let userId = json["id"] as? String {
            UserLoginData.shared.id = userId
        }
        if let user_id = json["user_id"] as? String {
            SubjectDetails.shared.user_id = user_id
        }
        if let subject_id = json["subject_id"] as? String {
            SubjectDetails.shared.subject_id = subject_id
        }
        if let grade = json["grade"] as? String {
            SubjectDetails.shared.grade = grade
        }
        if let add_date = json["add_date"] as? String {
            SubjectDetails.shared.add_date = add_date
        }
        if let subjectName = json["name"] as? String {
            SubjectDetails.shared.name = subjectName
        }
    }
}


class TutorList{
    
    var id : String!
    var name : String!
    var username : String!
    var email : String!
    var contact_number : String!
    var study_type : String!
    var school_id : String!
    var university_id : String!
    var year : String!
    var hourly_rate : String!
    var password : String!
    var set_password_key : String!
    var is_admin : String!
    var is_registered : String!
    var user_type : String!
    var profile_image : String!
    var is_email_verified : String!
    var token : String!
    var device_token : String!
    var device_type : String!
    var status : String!
    var add_date : String!
    var forgot_password_key : String!
    var expire_time : String!
    var email_verified_key : String!
    var update_date : String!
    var is_favourite : String!
    var education_name : String!
    var admin_commision: String!
    var avg_rating: String!
    var subject_detail : [TutorSubject]!
    
    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        self.id = parseData["id"].stringValue
        self.name = parseData["name"].stringValue
        self.username = parseData["username"].stringValue
        self.email = parseData["email"].stringValue
        self.contact_number = parseData["contact_number"].stringValue
        self.study_type = parseData["study_type"].stringValue
        self.school_id = parseData["school_id"].stringValue
        self.university_id = parseData["university_id"].stringValue
        self.year = parseData["year"].stringValue
        self.hourly_rate = parseData["hourly_rate"].stringValue
        self.password = parseData["password"].stringValue
        self.set_password_key = parseData["set_password_key"].stringValue
        self.is_admin = parseData["is_admin"].stringValue
        self.is_registered = parseData["is_registered"].stringValue
        
        self.user_type = parseData["user_type"].stringValue
        self.profile_image = parseData["profile_image"].stringValue
        self.is_email_verified = parseData["is_email_verified"].stringValue
        self.token = parseData["token"].stringValue
        self.device_token = parseData["device_token"].stringValue
        self.device_type = parseData["device_type"].stringValue
        self.status = parseData["status"].stringValue
        self.add_date = parseData["add_date"].stringValue
        
        self.forgot_password_key = parseData["forgot_password_key"].stringValue
        self.expire_time = parseData["expire_time"].stringValue
        self.email_verified_key = parseData["email_verified_key"].stringValue
        self.update_date = parseData["update_date"].stringValue
        self.is_favourite = parseData["is_favourite"].stringValue
        self.education_name = parseData["education_name"].stringValue
        self.admin_commision = parseData["admin_commision"].stringValue
        self.avg_rating = parseData["avg_rating"].stringValue
        let subject = parseData["subject_detail"].array
        subject_detail = [TutorSubject]()
        for objSubject in subject!{
            let tempObj = TutorSubject(fromJson: objSubject)
            subject_detail.append(tempObj)
        }
    }
}

class TutorSubject {
    var id : String!
    var user_id : String!
    var subject_id : String!
    var grade : String!
    var add_date : String!
    var name : String!
    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        self.id = parseData["id"].stringValue
        self.user_id = parseData["user_id"].stringValue
        self.subject_id = parseData["subject_id"].stringValue
        self.grade = parseData["grade"].stringValue
        self.add_date = parseData["add_date"].stringValue
        self.name = parseData["name"].stringValue
    }
}

class RequstListForTutor{
    var id : String!
    var student_id : String!
    var tutor_id : String!
    var study_date : String!
    var start_time : String!
    var end_time : String!
    var start_date_time_gmt : String!
    var end_date_time_gmt : String!
    var address : String!
    var latitude : String!
    var longitude : String!
    var message : String!
    var hours : String!
    var tutor_fee_per_hour : String!
    var admin_commision : String!
    var status : String!
    var add_date : String!
    var update_date : String!
    var user_id : String!
    var name : String!
    var username : String!
    var hourly_rate : String!
    var profile_image : String!
    var contact_number : String!
    var is_favourite : String!
    
    var request_status : String!
    var year : String!
    var is_time_out: String!
    var avg_rating: String!
    var study_subjects : [TutorStudySubject]!

    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        self.id = parseData["id"].stringValue
        self.student_id = parseData["student_id"].stringValue
        self.tutor_id = parseData["tutor_id"].stringValue
        self.study_date = parseData["study_date"].stringValue
        self.start_time = parseData["start_time"].stringValue
        self.end_time = parseData["end_time"].stringValue
        self.start_date_time_gmt = parseData["start_date_time_gmt"].stringValue
        self.end_date_time_gmt = parseData["end_date_time_gmt"].stringValue
        self.address = parseData["address"].stringValue
        self.latitude = parseData["latitude"].stringValue
        self.longitude = parseData["longitude"].stringValue
        self.message = parseData["message"].stringValue
        self.hours = parseData["hours"].stringValue
        self.tutor_fee_per_hour = parseData["tutor_fee_per_hour"].stringValue
        self.admin_commision = parseData["admin_commision"].stringValue
        self.status = parseData["status"].stringValue
        self.add_date = parseData["add_date"].stringValue
        self.update_date = parseData["update_date"].stringValue
        self.user_id = parseData["user_id"].stringValue
        self.name = parseData["name"].stringValue
        self.username = parseData["username"].stringValue
        self.hourly_rate = parseData["hourly_rate"].stringValue
        self.profile_image = parseData["profile_image"].stringValue
        self.contact_number = parseData["contact_number"].stringValue
        self.is_favourite = parseData["is_favourite"].stringValue
        
        self.request_status = parseData["request_status"].stringValue
        self.year = parseData["year"].stringValue
        self.is_time_out = parseData["is_time_out"].stringValue
        self.avg_rating = parseData["avg_rating"].stringValue
        let subject = parseData["study_subjects"].array
        self.study_subjects = [TutorStudySubject]()
        for objSubject in subject!{
            let tempObj = TutorStudySubject(fromJson: objSubject)
            self.study_subjects.append(tempObj)
        }
    }
}
class TutorStudySubject {
    var id : String!
    var request_id : String!
    var subject_id : String!
    var add_date : String!
    var name : String!
    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        self.id = parseData["id"].stringValue
        self.request_id = parseData["request_id"].stringValue
        self.subject_id = parseData["subject_id"].stringValue
        self.add_date = parseData["add_date"].stringValue
        self.name = parseData["name"].stringValue
    }
}


class FavouriteTutorList{
    var user_favourite_id : String!
    var id : String!
    var name : String!
    var username : String!
    var email : String!
    var contact_number : String!
    var study_type : String!
    var school_id : String!
    var university_id : String!
    var year : String!
    var hourly_rate : String!
    var password : String!
    var set_password_key : String!
    var is_admin : String!
    var is_registered : String!
    var user_type : String!
    var profile_image : String!
    var is_email_verified : String!
    var token : String!
    var device_token : String!
    var device_type : String!
    var status : String!
    var add_date : String!
    var forgot_password_key : String!
    var expire_time : String!
    var email_verified_key : String!
    var update_date : String!
    var admin_commision : String!
    var avg_rating : String!
    var subject_detail : [TutorSubject]!
    
    
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        self.user_favourite_id = parseData["user_favourite_id"].stringValue
        self.id = parseData["id"].stringValue
        self.name = parseData["name"].stringValue
        self.username = parseData["username"].stringValue
        self.email = parseData["email"].stringValue
        self.contact_number = parseData["contact_number"].stringValue
        self.study_type = parseData["study_type"].stringValue
        self.school_id = parseData["school_id"].stringValue
        self.university_id = parseData["university_id"].stringValue
        self.year = parseData["year"].stringValue
        self.hourly_rate = parseData["hourly_rate"].stringValue
        self.password = parseData["password"].stringValue
        self.set_password_key = parseData["set_password_key"].stringValue
        self.is_admin = parseData["is_admin"].stringValue
        self.is_registered = parseData["is_registered"].stringValue
        
        self.user_type = parseData["user_type"].stringValue
        self.profile_image = parseData["profile_image"].stringValue
        self.is_email_verified = parseData["is_email_verified"].stringValue
        self.token = parseData["token"].stringValue
        self.device_token = parseData["device_token"].stringValue
        self.device_type = parseData["device_type"].stringValue
        self.status = parseData["status"].stringValue
        self.add_date = parseData["add_date"].stringValue
        
        self.forgot_password_key = parseData["forgot_password_key"].stringValue
        self.expire_time = parseData["expire_time"].stringValue
        self.email_verified_key = parseData["email_verified_key"].stringValue
        self.update_date = parseData["update_date"].stringValue
        self.admin_commision = parseData["admin_commision"].stringValue
        self.avg_rating = parseData["avg_rating"].stringValue
        let subject = parseData["subject_detail"].array
        subject_detail = [TutorSubject]()
        for objSubject in subject!{
            let tempObj = TutorSubject(fromJson: objSubject)
            subject_detail.append(tempObj)
        }
    }
}

class TutorWalletHistory{
    var datetime : String!
    var transaction_date : String!
    var wallet_record : [TutorWalletRecord]!
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        self.datetime = parseData["datetime"].stringValue
        self.transaction_date = parseData["transaction_date"].stringValue
        let historyList = parseData["history"].array
        self.wallet_record = [TutorWalletRecord]()
        for objRecord in historyList!{
            let tempObj = TutorWalletRecord(fromJson: objRecord)
            self.wallet_record.append(tempObj)
        }
    }
}



class TutorWalletRecord {
    var student_request_id : String!
    var transaction_date : String!
    var transaction_id : String!
    var id : String!
    var added_amount : String!
    var available_balance : String!
    var is_withdraw : String!
    var user_id : String!
    var withdraw_amount : String!
    var transaction_time : String!
    var withdraw_status : String!
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        self.student_request_id = parseData["student_request_id"].stringValue
        self.transaction_date = parseData["transaction_date"].stringValue
        self.transaction_id = parseData["transaction_id"].stringValue
        self.id = parseData["id"].stringValue
        self.added_amount = parseData["added_amount"].stringValue
        self.available_balance = parseData["available_balance"].stringValue
        self.is_withdraw = parseData["is_withdraw"].stringValue
        self.user_id = parseData["user_id"].stringValue
        self.withdraw_amount = parseData["withdraw_amount"].stringValue
        self.transaction_time = parseData["transaction_time"].stringValue
        self.withdraw_status = parseData["withdraw_status"].stringValue
    }
}
class TutorRatingHistoryList {
   
    var id : String!
    var user_id : String!
    var other_user_id : String!
    var job_id : String!
    var rating : String!
    var description : String!
    var add_date : String!
    var update_date : String!
    var name : String!
    var profile_image : String!
    init(fromJson parseData: JSON!){
        if parseData.isEmpty{
            return
        }
        
        self.id = parseData["id"].stringValue
        self.user_id = parseData["user_id"].stringValue
        self.other_user_id = parseData["other_user_id"].stringValue
        self.job_id = parseData["job_id"].stringValue
        self.rating = parseData["rating"].stringValue
        self.description = parseData["description"].stringValue
        self.add_date = parseData["add_date"].stringValue
        self.update_date = parseData["update_date"].stringValue
        self.name = parseData["name"].stringValue
        self.profile_image = parseData["profile_image"].stringValue
    }
}
