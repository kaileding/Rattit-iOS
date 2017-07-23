//
//  Question.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

class Question: MainContent {
    var id: String?
    var createdBy: String?
    var createdAt: Date?
    var createdByInfo: RattitUser?
    
    var title: String!
    var accessLevel: RattitContentAccessLevel = .levelPublic
    var interestsNumber: Int = 0
    var invitesNumber: Int = 0
    var pitysNumber: Int = 0
    
    // optional fields
    var words: String? = nil
    var photos: [Photo]? = nil
    var hashTags: [String]? = nil
    var attachmentUrl: String? = nil
    var RattitLocationId: String? = nil
    
//    static func parseFromJson(dataValue: Any) -> MainContent? {
//        return Question(dataValue: dataValue)
//    }
    
    required init?(dataValue: Any) {
        guard let json = dataValue as? [String: Any],
            let id = json["id"] as? String,
            let title = json["title"] as? String,
            let createdBy = json["createdBy"] as? String,
            let createdAtStr = json["createdAt"] as? String,
            let createdAt = createdAtStr.utcStringToDate,
            let accessLevel = json["access_level"] as? String,
            let interestsNumber = json["interests_number"] as? Int,
            let invitesNumber = json["invites_number"] as? Int,
            let pitysNumber = json["pitys_number"] as? Int
            else {
                return nil
        }
        
        self.id = id
        self.createdBy = createdBy
        self.createdAt = createdAt
        
        self.title = title
        self.accessLevel = RattitContentAccessLevel(rawValue: accessLevel) ?? .levelPublic
        self.interestsNumber = interestsNumber
        self.invitesNumber = invitesNumber
        self.pitysNumber = pitysNumber
        
        if let words = json["words"] as? String {
            self.words = words
        }
        if let photosDataValues = json["photos"] as? [Any] {
            var tempPhotos: [Photo] = []
            photosDataValues.forEach { (photoData) in
                if let tempPhoto = Photo(dataValue: photoData) {
                    tempPhotos.append(tempPhoto)
                }
            }
            self.photos = tempPhotos
        }
        if let hashTags = json["hash_tags"] as? [String] {
            self.hashTags = hashTags
        }
        if let attachmentUrl = json["attachment"] as? String {
            self.attachmentUrl = attachmentUrl
        }
        if let RattitLocationId = json["location_id"] as? String {
            self.RattitLocationId = RattitLocationId
        }
        
        // additional information
        if let rattitUserObj = json["rattit_user"] {
            self.createdByInfo = RattitUser(dataValue: rattitUserObj)
        }
        
    }
    
    init(title: String, accessLevel: RattitContentAccessLevel, createdBy: String) {
        self.title = title
        self.accessLevel = accessLevel
        self.id = nil
        self.createdBy = createdBy
        self.createdAt = nil
    }
}
