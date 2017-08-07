//
//  CommentForAnswer.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

class CommentForAnswer: MainContent {
    var id: String?
    var createdBy: String?
    var createdAt: Date?
    var createdByInfo: RattitUser?
    var dataFlowContentUnit: DataFlowContentUnit?
    
    var forAnswer: String!
    var words: String!
    var likedBy: [String] = []
    
    // optional fields
    var forComment: String? = nil
    
    required init?(dataValue: Any) {
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
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.dataFlowContentUnit = DataFlowContentUnit(contentType: .answerComment, id: id, createdAt: createdAt)
        
        self.forAnswer = forAnswer
        self.words = words
        self.likedBy = likedBy
        
        if let forComment = json["for_comment"] as? String {
            self.forComment = forComment
        }
        
        // additional information
        if let rattitUserObj = json["rattit_user"] {
            self.createdByInfo = RattitUser(dataValue: rattitUserObj)
        }
    }
    
    init(forAnswer: String, words: String, createdBy: String) {
        self.forAnswer = forAnswer
        self.words = words
        self.createdBy = createdBy
        self.id = nil
        self.createdBy = createdBy
        self.createdAt = nil
        self.dataFlowContentUnit = nil
    }
    
}
