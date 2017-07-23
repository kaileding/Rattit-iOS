//
//  MainContent.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

protocol MainContent {
    var id: String? { get }
    var createdBy: String? { get }
    var createdAt: Date? { get }
    
    // optional fields
    var createdByInfo: RattitUser? { get }
    
//    init(id: String?, createdBy: String, createdAt: Date?) {
//        self.id = id
//        self.createdBy = createdBy
//        self.createdAt = createdAt
//    }
    
    init?(dataValue: Any)
//    static func parseFromJson(dataValue: Any) -> MainContent?
}
