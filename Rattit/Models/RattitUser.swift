//
//  RattitUser.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

struct RattitUser {
    var id: String?
    var userName: String
    var email: String
    var firstName: String
    var lastName: String
    var gender: RattitUserGender
    var followerNumber: Int = 0
    var followeeNumber: Int = 0
    var createdAt: Date? = nil
    
    // optional fields
    var manifesto: String = ""
    var organization: [String] = []
    var avatarUrl: String? = nil
    
    init?(dataValue: Any) {
        guard let json = dataValue as? [String: Any],
            let id = json["id"] as? String,
            let userName = json["username"] as? String,
            let email = json["email"] as? String,
            let firstName = json["first_name"] as? String,
            let lastName = json["last_name"] as? String,
            let gender = json["gender"] as? String,
            let followerNumber = json["follower_number"] as? Int,
            let followeeNumber = json["followee_number"] as? Int,
            let createdAt = json["createdAt"] as? Date
            else {
                return nil
        }
        self.id = id
        self.userName = userName
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.gender = RattitUserGender(rawValue: gender) ?? .untold
        self.followerNumber = followerNumber
        self.followeeNumber = followeeNumber
        self.createdAt = createdAt
        
        if let manifesto = json["manifesto"] as? String {
            self.manifesto = manifesto
        }
        if let organization = json["organization"] as? [String] {
            self.organization = organization
        }
        if let avatarUrl = json["avatar"] as? String {
            self.avatarUrl = avatarUrl
        }
    }
    
    init(userName: String, email: String, firstName: String, lastName: String, gender: RattitUserGender) {
        self.userName = userName
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
    }
    
    
}
