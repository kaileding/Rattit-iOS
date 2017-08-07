//
//  CommentForMoment.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

class CommentForMoment: MainContent {
    var id: String?
    var createdBy: String?
    var createdAt: Date?
    var createdByInfo: RattitUser?
    var dataFlowContentUnit: DataFlowContentUnit?
    
    var forMoment: String!
    var words: String!
    var likedBy: [String] = []
    var dislikedBy: [String] = []
    
    // optional fields
    var forComment: String? = nil
    var photos: [Photo]? = nil
    var hashTags: [String]? = nil
    
    required init?(dataValue: Any) {
        guard let json = dataValue as? [String: Any],
            let id = json["id"] as? String,
            let forMoment = json["for_moment"] as? String,
            let words = json["words"] as? String,
            let likedBy = json["likedBy"] as? [String],
            let dislikedBy = json["dislikedBy"] as? [String],
            let createdBy = json["createdBy"] as? String,
            let createdAtStr = json["createdAt"] as? String,
            let createdAt = createdAtStr.utcStringToDate
            else {
                return nil
        }
        
        self.id = id
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.dataFlowContentUnit = DataFlowContentUnit(contentType: .momentComment, id: id, createdAt: createdAt)
        
        self.forMoment = forMoment
        self.words = words
        self.likedBy = likedBy
        self.dislikedBy = dislikedBy
        
        if let forComment = json["for_comment"] as? String {
            self.forComment = forComment
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
        
        // additional information
        if let rattitUserObj = json["rattit_user"] {
            self.createdByInfo = RattitUser(dataValue: rattitUserObj)
        }
    }
    
    init(forMoment: String, words: String, createdBy: String) {
        self.forMoment = forMoment
        self.words = words
        self.createdBy = createdBy
        self.id = nil
        self.createdBy = createdBy
        self.createdAt = nil
        self.dataFlowContentUnit = nil
    }
    
}
