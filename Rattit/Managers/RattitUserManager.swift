//
//  RattitUserManager.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import UIKit

class RattitUserManager: NSObject {
    var cachedUsers: [String: RattitUser] = [:] // id: RattitUser
    var cachedAvatars: [String: UIImage] = [:] // url: UIImage
    
    var lastRefreshTime: Date? = nil
    
    static let sharedInstance: RattitUserManager = RattitUserManager()
    
    func getAllRattitUsers(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        Network.sharedInstance.callRattitContentService(httpRequest: .GetUsers, completion: { (dataValue) in
            
            if let json = dataValue as? [String: Any], let count = json["count"] as? Int, let rows = json["rows"] as? [Any] {
                print("RattitUserManager.getAllRattitUsers() got \(count) users.")
                
                rows.forEach({ (dataValue) in
                    if let rattitUser = RattitUser(dataValue: dataValue) {
                        self.cachedUsers[rattitUser.id!] = rattitUser
                    }
                })
                
                DispatchQueue.main.async {
                    self.lastRefreshTime = Date()
                    completion()
                }
            } else {
                DispatchQueue.main.async {
                    errorHandler(RattitError.parseError(message: "dataValue unable to be parsed into array of users."))
                }
            }
        }, errorHandler: { (error) in
            errorHandler(error)
        })
    }
    
    func getRattitUserForId(id: String, completion: @escaping (RattitUser) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if let foundUser = self.cachedUsers[id] {
            completion(foundUser)
        } else {
            Network.sharedInstance.callRattitContentService(httpRequest: .getUserWithId(id: id), completion: { (dataValue) in
                
                if let parsedUser = RattitUser(dataValue: dataValue) {
                    self.cachedUsers[id] = parsedUser
                    DispatchQueue.main.async {
                        completion(parsedUser)
                    }
                } else {
                    DispatchQueue.main.async {
                        errorHandler(RattitError.parseError(message: "dataValue unable to be parsed into RattitUser type."))
                    }
                }
                
            }, errorHandler: { (error) in
                errorHandler(error)
            })
        }
        
    }
    
    func getRattitUserAvatarImage(userId: String, completion: @escaping (UIImage) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getRattitUserForId(id: userId, completion: { (foundUser) in
            
            if let avatarUrl = foundUser.avatarUrl {
                if let avatarImage = self.cachedAvatars[avatarUrl] {
                    completion(avatarImage)
                } else {
                    Network.sharedInstance.callS3ToLoadImage(imageUrl: avatarUrl, completion: { (imageData) in
                        if let avatarImage = UIImage(data: imageData) {
                            self.cachedAvatars[avatarUrl] = avatarImage
                            completion(avatarImage)
                        } else {
                            errorHandler(RattitError.parseError(message: "Unable to create UIImage from data."))
                        }
                        
                    }, errorHandler: { (error) in
                        errorHandler(error)
                    })
                }
            } else {
                errorHandler(RattitError.caseError(message: "The User(id: \(userId)) does not have avatar URL."))
            }
            
        }) { (error) in
            errorHandler(error)
        }
    }
    
}
