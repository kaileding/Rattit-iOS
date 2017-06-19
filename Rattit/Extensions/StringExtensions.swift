//
//  StringExtensions.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

extension String {
    
    //MARK:UTCStringToDate
    var utcStringToDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let utcDate = dateFormatter.date(from: self)
        
        return utcDate
    }
}
