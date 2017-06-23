//
//  DateExtensions.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

extension Date {
    
    //MARK:DateToUTCString
    var dateToUtcString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let utcString = dateFormatter.string(from: self)
        
        return utcString
    }
    
    var dateToPostTimeDescription: String {
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let timeDiff = Calendar.current.dateComponents(components, from: self, to: Date())
        
        if (timeDiff.year! == 0 && timeDiff.month! == 0 && timeDiff.day! < 7) {
            if (timeDiff.day! > 1) {
                return "\(timeDiff.day!) days ago"
            } else if (timeDiff.day! == 1) {
                return "1 day ago"
            } else if (timeDiff.hour! > 1) {
                return "\(timeDiff.hour!) hours ago"
            } else if (timeDiff.hour! == 1) {
                return "1 hour ago"
            } else if (timeDiff.minute! > 1) {
                return "\(timeDiff.minute!) mins ago"
            } else if (timeDiff.minute! == 1) {
                return "1 min ago"
            } else if (timeDiff.second! > 1) {
                return "\(timeDiff.second!) secs ago"
            } else {
                return "1 sec ago"
            }
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: self)
        }
    }
}
