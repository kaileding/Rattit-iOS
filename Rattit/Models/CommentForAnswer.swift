//
//  CommentForAnswer.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

struct CommentForAnswer {
    var id: String? = nil
    var forAnswer: String!
    var words: String!
    var likedBy: [String] = []
    var createdBy: String!
    var createdAt: Date? = nil
    
    // optional fields
    var forComment: String? = nil
    
    init?(dataValue: Any) {
        guard let json = dataValue as? [String: Any],
            let id = json["id"] as? String,
            let forAnswer = json["for_answer"] as? String,
            let words = json["words"] as? String,
            let likedBy = json["likedBy"] as? [String],
            let createdBy = json["createdBy"] as? String,
            let createdAtStr = json["createdAt"] as? String,
            let createdAt = createdAtStr.utcStringToDate
            else {
                return nil
        }
        
        self.id = id
        self.forAnswer = forAnswer
        self.words = words
        self.likedBy = likedBy
        self.createdBy = createdBy
        self.createdAt = createdAt
        
        if let forComment = json["for_comment"] as? String {
            self.forComment = forComment
        }
    }
    
    init(forAnswer: String, words: String, createdBy: String) {
        self.forAnswer = forAnswer
        self.words = words
        self.createdBy = createdBy
    }
    
}
