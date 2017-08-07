//
//  VoteForMoment.swift
//  Rattit
//
//  Created by DINGKaile on 8/6/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

struct VoteForMoment {
    var id: String!
    var voteType: RattitMomentVoteType!
    var voterId: String!
    var votedAt: Date!
    var momentId: String!
    
    init?(dataValue: Any) {
        guard let json = dataValue as? [String: Any],
            let id = json["id"] as? String,
            let voteTypeStr = json["vote_type"] as? String,
            let voteType = RattitMomentVoteType(rawValue: voteTypeStr),
            let voterId = json["createdBy"] as? String,
            let votedAtStr = json["createdAt"] as? String,
            let votedAt = votedAtStr.utcStringToDate,
            let momentId = json["moment_id"] as? String
            else {
                return nil
        }
        
        self.id = id
        self.voteType = voteType
        self.voterId = voterId
        self.votedAt = votedAt
        self.momentId = momentId
    }
}
