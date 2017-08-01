//
//  DateExtensions.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

extension Date {
    
    //MARK: DateToUTCString
    var dateToUtcString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let utcString = dateFormatter.string(from: self)
        
        return utcString
    }
    
    // MARK: DateToPostTimeRelativeToCurrentTime
    var dateToPostTimeDescription: String {
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let timeDiff = Calendar.current.dateComponents(components, from: self, to: Date())
        
        if (timeDiff.year! == 0 && timeDiff.month! == 0 && timeDiff.day! < 7) {
            if (timeDiff.day! > 1) {
                return "\(timeDiff.day!) DAYS AGO"
            } else if (timeDiff.day! == 1) {
                return "1 DAY AGO"
            } else if (timeDiff.hour! > 1) {
                return "\(timeDiff.hour!) HOURS AGO"
            } else if (timeDiff.hour! == 1) {
                return "1 HOUR AGO"
            } else if (timeDiff.minute! > 1) {
                return "\(timeDiff.minute!) MINS AGO"
            } else if (timeDiff.minute! == 1) {
                return "1 MIN AGO"
            } else if (timeDiff.second! > 1) {
                return "\(timeDiff.second!) SECS AGO"
            } else {
                return "1 SEC AGO"
            }
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            return dateFormatter.string(from: self)
        }
    }
    
    // MARK: DateToPostTimeAbsoluteAtLocalTime
    var dateToPostTimeAbsDescription: String {
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let timeComponents = Calendar.current.dateComponents(components, from: self)
        
        return "\(timeComponents.hour!):\(timeComponents.minute!):\(timeComponents.second!) \(timeComponents.month!)/\(timeComponents.day!)/\(timeComponents.year!)"
    }
}
