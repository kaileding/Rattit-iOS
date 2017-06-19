//
//  Moment.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

struct Moment {
    var id: String? = nil
    var title: String!
    var words: String!
    var accessLevel: RattitContentAccessLevel = .levelPublic
    var likersNumber: Int = 0
    var admirersNumber: Int = 0
    var pitysNumber: Int = 0
    var createdBy: String
    var createdAt: Date? = nil
    
    // optional fields
    var photos: [Photo]? = nil
    var hashTags: [String] = []
    var attachmentUrl: String? = nil
    var RattitLocationId: String? = nil
    var togetherWith: [String] = []
    
    init?(dataValue: Any) {
        guard let json = dataValue as? [String: Any],
            let id = json["id"] as? String,
            let title = json["title"] as? String,
            let words = json["words"] as? String,
            let createdBy = json["createdBy"] as? String,
            let createdAt = json["createdAt"] as? String,
            let accessLevel = json["access_level"] as? String,
            let likersNumber = json["likers_number"] as? Int,
            let admirersNumber = json["admirers_number"] as? Int,
            let pitysNumber = json["pitys_number"] as? Int
            else {
                return nil
        }
        
        self.id = id
        self.title = title
        self.words = words
        self.createdBy = createdBy
        self.createdAt = createdAt.utcStringToDate
        self.accessLevel = RattitContentAccessLevel(rawValue: accessLevel) ?? .levelPublic
        self.likersNumber = likersNumber
        self.admirersNumber = admirersNumber
        self.pitysNumber = pitysNumber
        
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
        if let togetherWith = json["together_with"] as? [String] {
            self.togetherWith = togetherWith
        }
    }
    
    init(title: String, words: String, accessLevel: RattitContentAccessLevel, createdBy: String) {
        self.title = title
        self.words = words
        self.accessLevel = accessLevel
        self.createdBy = createdBy
    }
}
