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
    static var cachedUsers: [String: RattitUser] = [:] // id: RattitUser
    static var cachedAvatars: [String: UIImage] = [:] // url: UIImage
    
    static var networkService: Network = Network()
    
    static func getRattitUserForId(id: String, completion: @escaping (RattitUser) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if let foundUser = RattitUserManager.cachedUsers[id] {
            completion(foundUser)
        } else {
            RattitUserManager.networkService.callRattitContentService(httpRequest: .getUserWithId(id: id), completion: { (dataValue) in
                
                if let parsedUser = RattitUser(dataValue: dataValue) {
                    RattitUserManager.cachedUsers[id] = parsedUser
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
    
    static func getRattitUserAvatarImage(userId: String, completion: @escaping (UIImage) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        RattitUserManager.getRattitUserForId(id: userId, completion: { (foundUser) in
            
            if let avatarUrl = foundUser.avatarUrl {
                if let avatarImage = RattitUserManager.cachedAvatars[avatarUrl] {
                    completion(avatarImage)
                } else {
                    RattitUserManager.networkService.callS3ToLoadImage(imageUrl: avatarUrl, completion: { (imageData) in
                        if let avatarImage = UIImage(data: imageData) {
                            RattitUserManager.cachedAvatars[avatarUrl] = avatarImage
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
