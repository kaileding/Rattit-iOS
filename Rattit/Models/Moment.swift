//
//  Moment.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

class Moment: NSObject {
    var title: String!
    var words: String!
    var photos: [Photo]
    
    init(title: String, words: String, photos: [Photo]) {
        self.title = title
        self.words = words
        self.photos = photos
    }
}
