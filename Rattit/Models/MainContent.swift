//
//  MainContent.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

class MainContent {
    var id: String? = nil
    var createdBy: String? = nil
    var createdAt: Date? = nil
    
    // optional fields
    var createdByInfo: RattitUser? = nil
    
    init(id: String?, createdBy: String, createdAt: Date?) {
        self.id = id
        self.createdBy = createdBy
        self.createdAt = createdAt
    }
}
