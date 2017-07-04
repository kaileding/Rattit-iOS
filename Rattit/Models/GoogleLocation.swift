//
//  GoogleLocation.swift
//  Rattit
//
//  Created by DINGKaile on 6/29/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import CoreLocation

struct GoogleLocation {
    var id: String? = nil
    var locPointLongitude: Double!
    var locPointLatitude: Double!
    var cLocationPoint: CLLocation!
    var name: String!
    
    // optional fields
    var iconUrl: String? = nil
    var types: [String]? = nil
    var googlePlaceId: String? = nil
    var addressStr: String? = nil
    
    init?(dataValue: Any) {
        guard let json = dataValue as? [String: Any],
            let id = json["id"] as? String,
            let geometry = json["geometry"] as? [String: Any], let locationObj = geometry["location"] as? [String: Double],
            let locPointLongitude = locationObj["lng"],
            let locPointLatitude = locationObj["lat"],
            let name = json["name"] as? String
            else {
                return nil
        }
        
        self.id = id
        self.locPointLongitude = locPointLongitude
        self.locPointLatitude = locPointLatitude
        self.cLocationPoint = CLLocation(latitude: locPointLatitude, longitude: locPointLongitude)
        self.name = name
        
        if let iconUrl = json["icon"] as? String {
            self.iconUrl = iconUrl
        }
        if let types = json["types"] as? [String] {
            self.types = types
        }
        if let googlePlaceId = json["place_id"] as? String {
            self.googlePlaceId = googlePlaceId
        }
        if let addressStr = json["vicinity"] as? String {
            self.addressStr = addressStr
        }
    }
    
    func wrapIntoLocationPostObj() -> [String: Any] {
        var locationPostObj = [String: Any]()
        locationPostObj["coordinates"] = ["longitude": self.locPointLongitude,
                                          "latitude": self.locPointLatitude] as Any
        locationPostObj["name"] = self.name as Any
        locationPostObj["icon_url"] = (self.iconUrl ?? NSNull()) as Any
        locationPostObj["types"] = (self.types ?? [String]()) as Any
        locationPostObj["google_place_id"] = (self.googlePlaceId ?? NSNull()) as Any
        
        return locationPostObj
    }
    
}
