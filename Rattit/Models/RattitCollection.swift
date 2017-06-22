//
//  RattitCollection.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

struct RattitCollection {
    var id: String? = nil
    var title: String!
    var accessLevel: RattitContentAccessLevel = .levelPublic
    var createdBy: String!
    var createdAt: Date? = nil
    var updatedAt: Date? = nil
    
    // optional fields
    var description: String? = nil
    var coverImageUrl: String? = nil
    var tags: [String]? = nil
    
    init?(dataValue: Any) {
        guard let json = dataValue as? [String: Any],
            let id = json["id"] as? String,
            let title = json["title"] as? String,
            let accessLevel = json["access_level"] as? String,
            let createdBy = json["createdBy"] as? String,
            let createdAtStr = json["createdAt"] as? String,
            let createdAt = createdAtStr.utcStringToDate,
            let updatedAtStr = json["updatedAt"] as? String,
            let updatedAt = updatedAtStr.utcStringToDate
            else {
                return nil
        }
        
        self.id = id
        self.title = title
        self.accessLevel = RattitContentAccessLevel(rawValue: accessLevel) ?? .levelPublic
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
        if let description = json["description"] as? String {
            self.description = description
        }
        if let coverImageUrl = json["cover_image"] as? String {
            self.coverImageUrl = coverImageUrl
        }
        if let tags = json["tags"] as? [String] {
            self.tags = tags
        }
    }
    
    init(title: String, accessLevel: RattitContentAccessLevel, createdBy: String) {
        self.title = title
        self.accessLevel = accessLevel
        self.createdBy = createdBy
    }
}
