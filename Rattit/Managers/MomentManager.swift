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
    var downloadedMoments: [String: Moment] = [:] // momentId : Moment
    var displaySequenceOfMoments: [String] = [] // Array of momentId
    var lastMomentCreatedAt: Date? = nil
    var lastMomentId: String? = nil
    var firstMomentCreatedAt: Date? = nil
    var firstMomentId: String? = nil
    var lastRefreshTime: Date? = nil
    
    static let sharedInstance: MomentManager = MomentManager()
    
    func loadMomentsFromServer(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        Network.sharedInstance.callRattitContentService(httpRequest: .GetMoments, completion: { (dataValue) in
            
            if let responseBody = dataValue as? [String: Any], let count = responseBody["count"] as? Int, let rows = responseBody["rows"] as? [Any] {
                
                print("Got \(count) moments from server.")
                self.downloadedMoments.removeAll()
                self.displaySequenceOfMoments.removeAll()
                rows.forEach({ (dataValue) in
                    if let moment = Moment(dataValue: dataValue) {
                        self.downloadedMoments[moment.id!] = moment
                        self.displaySequenceOfMoments.append(moment.id!)
                        if let momentAuthor = moment.createdByInfo, let authorId = moment.createdBy {
                            RattitUserManager.sharedInstance.cachedUsers[authorId] = momentAuthor
                        }
                    }
                })
                if let lastMomentId = self.displaySequenceOfMoments.first {
                    self.lastMomentCreatedAt = self.downloadedMoments[lastMomentId]!.createdAt
                    self.lastMomentId = lastMomentId
                }
                if let firstMomentId = self.displaySequenceOfMoments.last {
                    self.firstMomentCreatedAt = self.downloadedMoments[firstMomentId]!.createdAt
                    self.firstMomentId = firstMomentId
                }
                
                DispatchQueue.main.async {
                    self.lastRefreshTime = Date()
                    completion()
                }
            } else {
                DispatchQueue.main.async {
                    errorHandler(RattitError.parseError(message: "Unable to parse response data from getting moments."))
                }
            }
            
        }) { (error) in
            errorHandler(error)
        }
        
    }
    
    func loadMomentsUpdatesFromServer(completion: @escaping (Bool) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if (self.lastMomentCreatedAt != nil) {
            
            Network.sharedInstance.callRattitContentService(httpRequest: .getMomentsNoEarlierThan(timeThreshold: self.lastMomentCreatedAt!.dateToUtcString), completion: { (dataValue) in
                
                if let responseBody = dataValue as? [String: Any], let count = responseBody["count"] as? Int, let rows = responseBody["rows"] as? [Any] {
                    
                    print("Got \(count) more moments from server.")
                    if (count > 0) {
                        var newMoments: [String] = []
                        rows.forEach({ (dataValue) in
                            if let moment = Moment(dataValue: dataValue) {
                                self.downloadedMoments[moment.id!] = moment
                                if (moment.id != self.lastMomentId) {
                                    newMoments.append(moment.id!)
                                }
                                if let momentAuthor = moment.createdByInfo, let authorId = moment.createdBy {
                                    RattitUserManager.sharedInstance.cachedUsers[authorId] = momentAuthor
                                }
                            }
                        })
                        self.displaySequenceOfMoments.insert(contentsOf: newMoments, at: 0)
                        if let lastMomentId = newMoments.first {
                            self.lastMomentId = lastMomentId
                            self.lastMomentCreatedAt = self.downloadedMoments[lastMomentId]!.createdAt
                        }
                        
                        DispatchQueue.main.async {
                            self.lastRefreshTime = Date()
                            completion(newMoments.count > 0)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.lastRefreshTime = Date()
                            completion(false)
                        }
                    }
                }
                
            }, errorHandler: { (error) in
                errorHandler(error)
            })
            
        } else {
            print("lastMomentCreatedAt = nil, so loadMomentsFromServer() func called.")
            self.loadMomentsFromServer(completion: {
                completion(true)
            }, errorHandler: errorHandler)
        }
        
    }
    
    func getMomentsCreatedByAUser(userId: String, completion: @escaping ([String]) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        Network.sharedInstance.callRattitContentService(httpRequest: .getMomentsCreatedByUser(userId: userId), completion: { (dataValue) in
            
            if let responseBody = dataValue as? [String: Any], let count = responseBody["count"] as? Int, let rows = responseBody["rows"] as? [Any] {
                
                print("Got \(count) moments from server.")
                var momentsOfUser: [String] = []
                rows.forEach({ (dataValue) in
                    if let moment = Moment(dataValue: dataValue) {
                        self.downloadedMoments[moment.id!] = moment
                        momentsOfUser.append(moment.id!)
                    }
                })
                
                DispatchQueue.main.async {
                    completion(momentsOfUser)
                }
            } else {
                DispatchQueue.main.async {
                    errorHandler(RattitError.parseError(message: "Unable to parse response data from getting moments."))
                }
            }
            
        }) { (error) in
            errorHandler(error)
        }
        
    }
    
    func castVoteToAMoment(momentId: String, voteType: RattitMomentVoteType, commit: Bool, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
        Network.sharedInstance.callRattitContentService(httpRequest: .castVoteToAMoment(momentId: momentId, voteType: voteType, commit: commit), completion: { (dataValue) in
            
            if let moment = Moment(dataValue: dataValue) {
                self.downloadedMoments[moment.id!] = moment
                DispatchQueue.main.async {
                    completion()
                }
            }
        }) { (error) in
            print("Failed to cast vote to moment. Error is \(error.localizedDescription)")
            DispatchQueue.main.async {
                errorHandler()
            }
        }
    }
    
}
