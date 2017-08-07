//
//  VoteForQuestion.swift
//  Rattit
//
//  Created by DINGKaile on 8/6/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

struct VoteForQuestion {
    var id: String!
    var voteType: RattitQuestionVoteType!
    var voterId: String!
    var votedAt: Date!
    var questionId: String!
    var subjectId: String? = nil
    
    init?(dataValue: Any) {
        guard let json = dataValue as? [String: Any],
            let id = json["id"] as? String,
            let voteTypeStr = json["vote_type"] as? String,
            let voteType = RattitQuestionVoteType(rawValue: voteTypeStr),
            let voterId = json["createdBy"] as? String,
            let votedAtStr = json["createdAt"] as? String,
            let votedAt = votedAtStr.utcStringToDate,
            let questionId = json["question_id"] as? String
            else {
                return nil
        }
        
        self.id = id
        self.voteType = voteType
        self.voterId = voterId
        self.votedAt = votedAt
        self.questionId = questionId
        
        if let subjectId = json["subject_id"] as? String {
            self.subjectId = subjectId
        }
    }
}
