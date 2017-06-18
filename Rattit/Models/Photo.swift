//
//  Photo.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

class Photo: NSObject {
    var imageUrl: String!
    var width: Float!
    var height: Float!
    
    init(imageUrl: String, width: Float, height: Float) {
        self.imageUrl = imageUrl
        self.width = width
        self.height = height
    }
}
