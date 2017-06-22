//
//  RattitLocation.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

struct RattitLocation {
    var id: String? = nil
    var locPointLongitude: Double!
    var locPointLatitude: Double!
    var name: String!
    var createdBy: String!
    var createdAt: Date? = nil
    
    // optional fields
    var iconUrl: String? = nil
    var types: [String]? = nil
    var googlePlaceId: String? = nil
    
    init?(dataValue: Any) {
        guard let json = dataValue as? [String: Any],
            let id = json["id"] as? String,
            let locPoint = json["loc_point"] as? [String: Any],
            let locPointType = locPoint["type"] as? String, locPointType == "Point",
            let locPointCoordinates = locPoint["coordinates"] as? [Double], locPointCoordinates.count == 2,
            let name = json["name"] as? String,
            let createdBy = json["createdBy"] as? String,
            let createdAtStr = json["createdAt"] as? String,
            let createdAt = createdAtStr.utcStringToDate
            else {
                return nil
        }
        
        self.id = id
        self.locPointLatitude = locPointCoordinates[0]
        self.locPointLongitude = locPointCoordinates[1]
        self.name = name
        self.createdBy = createdBy
        self.createdAt = createdAt
        
        if let iconUrl = json["icon"] as? String {
            self.iconUrl = iconUrl
        }
        if let types = json["types"] as? [String] {
            self.types = types
        }
        if let googlePlaceId = json["google_place_id"] as? String {
            self.googlePlaceId = googlePlaceId
        }
    }
    
    init(longitude: Double, latitude: Double, name: String, createdBy: String) {
        self.locPointLongitude = longitude
        self.locPointLatitude = latitude
        self.name = name
        self.createdBy = createdBy
    }
    
}
