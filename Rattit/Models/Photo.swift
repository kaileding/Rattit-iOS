//
//  Photo.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

struct Photo {
    var imageUrl: String!
    var width: UInt!
    var height: UInt!
    
    init?(dataValue: Any) {
        guard let json = dataValue as? [String: Any],
            let imageUrl = json["image_url"] as? String,
            let width = json["width"] as? UInt,
            let height = json["height"] as? UInt
            else {
                return nil
        }
        self.imageUrl = imageUrl
        self.width = width
        self.height = height
    }
    
    init(imageUrl: String, width: UInt, height: UInt) {
        self.imageUrl = imageUrl
        self.width = width
        self.height = height
    }
}
