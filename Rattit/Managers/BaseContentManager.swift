//
//  BaseContentManager.swift
//  Rattit
//
//  Created by DINGKaile on 7/23/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import Alamofire

class BaseContentManager<T: MainContent>: NSObject {
    var downloadedContents: [String: T] = [:] // contentId : ContentT
    var displaySequenceOfContents: [DataFlowContentUnit] = [] // Array of DataFlowContentUnit
    var lastContentCreatedAt: Date? = nil
    var lastContentId: String? = nil
    var firstContentCreatedAt: Date? = nil
    var firstContentId: String? = nil
    var lastRefreshTime: Date? = nil
    
    var getAllContentsRequest: CommonRequest!
    var getContentsNoEarlierThanRequest: CommonRequest!
    var getContentsNoLaterThanRequest: CommonRequest!
    var getContentsCreatedByUserRequest: CommonRequest!
    
    func loadContentsFromServer(completion: @escaping ([String: Any]) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        Network.shared.callContentAPI(httpRequest: self.getAllContentsRequest, completion: { (dataValue) in
            
            if let responseBody = dataValue as? [String: Any], let count = responseBody["count"] as? Int, let rows = responseBody["rows"] as? [Any] {
                
                print("Got \(count) content units from server.")
                self.downloadedContents.removeAll()
                self.displaySequenceOfContents.removeAll()
                for rowValue in rows {
                    if let content = T(dataValue: rowValue) {
                        self.downloadedContents[content.id!] = content
                        self.displaySequenceOfContents.append(content.dataFlowContentUnit!)
                        if let contentAuthor = content.createdByInfo, let authorId = content.createdBy {
                            RattitUserManager.sharedInstance.cachedUsers[authorId] = contentAuthor
                        }
                    }
                }
                if let lastContentId = self.displaySequenceOfContents.first?.id {
                    self.lastContentCreatedAt = self.downloadedContents[lastContentId]!.createdAt
                    self.lastContentId = lastContentId
                }
                if let firstContentId = self.displaySequenceOfContents.last?.id {
                    self.firstContentCreatedAt = self.downloadedContents[firstContentId]!.createdAt
                    self.firstContentId = firstContentId
                }
                
                DispatchQueue.main.async {
                    self.lastRefreshTime = Date()
                    completion(responseBody)
                }
            } else {
                DispatchQueue.main.async {
                    errorHandler(RattitError.parseError(message: "Unable to parse response data from getting content units."))
                }
            }
            
        }) { (error) in
            errorHandler(error)
        }
        
    }
    
    func loadContentsUpdatesFromServer(completion: @escaping (Bool) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if (self.lastContentCreatedAt != nil) {
            
            Network.shared.callContentAPI(httpRequest: self.getContentsNoEarlierThanRequest, completion: { (dataValue) in
                
                if let responseBody = dataValue as? [String: Any], let count = responseBody["count"] as? Int, let rows = responseBody["rows"] as? [Any] {
                    
                    print("Got \(count) more content units from server.")
                    if (count > 0) {
                        var newContents: [DataFlowContentUnit] = []
                        rows.forEach({ (dataValue) in
                            if let content = T(dataValue: dataValue) {
                                self.downloadedContents[content.id!] = content
                                if (content.id != self.lastContentId) {
                                    newContents.append(content.dataFlowContentUnit!)
                                }
                                if let contentAuthor = content.createdByInfo, let authorId = content.createdBy {
                                    RattitUserManager.sharedInstance.cachedUsers[authorId] = contentAuthor
                                }
                            }
                        })
                        self.displaySequenceOfContents.insert(contentsOf: newContents, at: 0)
                        if let lastContentId = newContents.first?.id {
                            self.lastContentId = lastContentId
                            self.lastContentCreatedAt = self.downloadedContents[lastContentId]!.createdAt
                        }
                        
                        DispatchQueue.main.async {
                            self.lastRefreshTime = Date()
                            completion(newContents.count > 0)
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
            print("lastContentCreatedAt = nil, so loadContentsFromServer() func called.")
            self.loadContentsFromServer(completion: { (dataBody) in
                completion(true)
            }, errorHandler: errorHandler)
        }
        
    }
    
    func getContentsCreatedByAUser(completion: @escaping ([String]) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        Network.shared.callContentAPI(httpRequest: self.getContentsCreatedByUserRequest, completion: { (dataValue) in
            
            if let responseBody = dataValue as? [String: Any], let count = responseBody["count"] as? Int, let rows = responseBody["rows"] as? [Any] {
                
                print("Got \(count) content units from server.")
                var contentsOfUser: [String] = []
                rows.forEach({ (dataValue) in
                    if let content = T(dataValue: dataValue) {
                        self.downloadedContents[content.id!] = content
                        contentsOfUser.append(content.id!)
                    }
                })
                
                DispatchQueue.main.async {
                    completion(contentsOfUser)
                }
            } else {
                DispatchQueue.main.async {
                    errorHandler(RattitError.parseError(message: "Unable to parse response data from getting contents."))
                }
            }
            
        }) { (error) in
            errorHandler(error)
        }
        
    }
    
    func parseResultsToContentArray(responseBody: Any, resultsHandler: @escaping ([Any]) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if let jsonBody = responseBody as? [String: Any], let count = jsonBody["count"] as? Int, let rows = jsonBody["rows"] as? [Any] {
            
            print("Got \(count) content units from server.")
            resultsHandler(rows)
        } else {
            DispatchQueue.main.async {
                errorHandler(RattitError.parseError(message: "Unable to parse response data from getting contents."))
            }
        }
    }
    
}



