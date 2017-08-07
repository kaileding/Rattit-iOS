//
//  MomentManager.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import Alamofire

class MomentManager: BaseContentManager<Moment> {
    
    static let sharedInstance: MomentManager = MomentManager()
    
    func loadMomentsFromServer(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getAllContentsRequest = CommonRequest.GetMoments
        self.loadContentsFromServer(completion: { (dataBody) in
            completion()
        }, errorHandler: errorHandler)
    }
    
    func loadMomentsUpdatesFromServer(completion: @escaping (Bool) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getAllContentsRequest = CommonRequest.GetMoments
        if self.lastContentCreatedAt == nil {
            self.getContentsNoEarlierThanRequest = CommonRequest.GetMoments
        } else {
            self.getContentsNoEarlierThanRequest = CommonRequest.getMomentsNoEarlierThan(timeThreshold: self.lastContentCreatedAt!.dateToUtcString)
        }
        
        self.loadContentsUpdatesFromServer(completion: completion, errorHandler: errorHandler)
    }
    
    func getMomentsCreatedByAUser(userId: String, completion: @escaping ([String]) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getContentsCreatedByUserRequest = CommonRequest.getMomentsCreatedByUser(userId: userId)
        self.getContentsCreatedByAUser(completion: completion, errorHandler: errorHandler)
    }
    
    func castVoteToAMoment(momentId: String, voteType: RattitMomentVoteType, commit: Bool, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
        Network.shared.callContentAPI(httpRequest: .castVoteToAMoment(momentId: momentId, voteType: voteType, commit: commit), completion: { (dataValue) in
            
            if let moment = Moment(dataValue: dataValue) {
                self.downloadedContents[moment.id!] = moment
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
    
    func getVotesToMomentCreatedByAUser(userId: String, completion: @escaping ([VoteForMoment]) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        Network.shared.callContentAPI(httpRequest: .getVotesOfAUserForMoments(userId: userId), completion: { (dataValue) in
            
            self.parseResultsToContentArray(responseBody: dataValue, resultsHandler: { (rows) in
                
                var votesOfUser: [VoteForMoment] = []
                rows.forEach({ (dataValue) in
                    if let vote = VoteForMoment(dataValue: dataValue) {
                        votesOfUser.append(vote)
                    }
                })
                
                DispatchQueue.main.async {
                    completion(votesOfUser)
                }
                
            }, errorHandler: errorHandler)
            
        }) { (error) in
            print("Unable to get votes of moments created by a user, error is ", error.localizedDescription)
            DispatchQueue.main.async {
                errorHandler(error)
            }
        }
    }
    
}
