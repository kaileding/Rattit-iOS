//
//  MomentManager.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import Alamofire

class MomentManager: NSObject {
    static var downloadedMoments: [Moment] = []
    static var lastMomentCreatedAt: Date? = nil
    static var lastMomentId: String? = nil
    static var firstMomentCreatedAt: Date? = nil
    static var firstMomentId: String? = nil
    static var lastRefreshTime: Date? = nil
    static var networkService: Network = Network()
    
    static func loadMomentsFromServer(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        MomentManager.networkService.callRattitContentService(httpRequest: .GetMoments, completion: { (dataValue) in
            
            if let responseBody = dataValue as? [String: Any], let count = responseBody["count"] as? Int, let rows = responseBody["rows"] as? [Any] {
                
                print("Got \(count) moments from server.")
                MomentManager.downloadedMoments = []
                rows.forEach({ (dataValue) in
                    if let moment = Moment(dataValue: dataValue) {
                        MomentManager.downloadedMoments.append(moment)
                        if let momentAuthor = moment.createdByInfo, let authorId = moment.createdBy {
                            RattitUserManager.cachedUsers[authorId] = momentAuthor
                        }
                    }
                })
                if let lastMoment = MomentManager.downloadedMoments.first {
                    MomentManager.lastMomentCreatedAt = lastMoment.createdAt
                    MomentManager.lastMomentId = lastMoment.id
                }
                if let firstMoment = MomentManager.downloadedMoments.last {
                    MomentManager.firstMomentCreatedAt = firstMoment.createdAt
                    MomentManager.firstMomentId = firstMoment.id
                }
                
                DispatchQueue.main.async {
                    MomentManager.lastRefreshTime = Date()
                    completion()
                }
            }
            
        }) { (error) in
            errorHandler(error)
        }
        
    }
    
    static func loadMomentsUpdatesFromServer(completion: @escaping (Bool) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if (MomentManager.lastMomentCreatedAt != nil) {
            
            MomentManager.networkService.callRattitContentService(httpRequest: .getMomentsNoEarlierThan(timeThreshold: MomentManager.lastMomentCreatedAt!.dateToUtcString), completion: { (dataValue) in
                
                if let responseBody = dataValue as? [String: Any], let count = responseBody["count"] as? Int, let rows = responseBody["rows"] as? [Any] {
                    
                    print("Got \(count) more moments from server.")
                    if (count > 0) {
                        var newMoments: [Moment] = []
                        rows.forEach({ (dataValue) in
                            if let moment = Moment(dataValue: dataValue) {
                                if (moment.id != MomentManager.lastMomentId) {
                                    newMoments.append(moment)
                                }
                                if let momentAuthor = moment.createdByInfo, let authorId = moment.createdBy {
                                    RattitUserManager.cachedUsers[authorId] = momentAuthor
                                }
                            }
                        })
                        MomentManager.downloadedMoments.insert(contentsOf: newMoments, at: 0)
                        if let lastMoment = newMoments.first {
                            MomentManager.lastMomentId = lastMoment.id
                            MomentManager.lastMomentCreatedAt = lastMoment.createdAt
                        }
                        
                        DispatchQueue.main.async {
                            MomentManager.lastRefreshTime = Date()
                            completion(newMoments.count > 0)
                        }
                    } else {
                        DispatchQueue.main.async {
                            MomentManager.lastRefreshTime = Date()
                            completion(false)
                        }
                    }
                }
                
            }, errorHandler: { (error) in
                errorHandler(error)
            })
            
        } else {
            print("lastMomentCreatedAt = nil, so loadMomentsFromServer() func called.")
            MomentManager.loadMomentsFromServer(completion: {
                completion(true)
            }, errorHandler: errorHandler)
        }
        
    }
    
}
