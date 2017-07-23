//
//  AnswerManager.swift
//  Rattit
//
//  Created by DINGKaile on 7/23/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import Alamofire

class AnswerManager: BaseContentManager<Answer> {
    
    static let sharedInstance: AnswerManager = AnswerManager()
    
    func loadAnswersFromServer(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getAllContentsRequest = CommonRequest.GetAnswers
        self.loadContentsFromServer(completion: completion, errorHandler: errorHandler)
    }
    
    func loadAnswersUpdatesFromServer(completion: @escaping (Bool) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getAllContentsRequest = CommonRequest.GetAnswers
        if self.lastContentCreatedAt == nil {
            self.getContentsNoEarlierThanRequest = CommonRequest.GetAnswers
        } else {
            self.getContentsNoEarlierThanRequest = CommonRequest.getAnswersNoEarlierThan(timeThreshold: self.lastContentCreatedAt!.dateToUtcString)
        }
        
        self.loadContentsUpdatesFromServer(completion: completion, errorHandler: errorHandler)
    }
    
    func getAnswersCreatedByAUser(userId: String, completion: @escaping ([String]) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getContentsCreatedByUserRequest = CommonRequest.getAnswersCreatedByUser(userId: userId)
        self.getContentsCreatedByAUser(completion: completion, errorHandler: errorHandler)
    }
    
    func castVoteToAnAnswer(answerId: String, voteType: RattitAnswerVoteType, commit: Bool, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
        Network.sharedInstance.callRattitContentService(httpRequest: .castVoteToAnAnswer(answerId: answerId, voteType: voteType, commit: commit), completion: { (dataValue) in
            
            if let answer = Answer(dataValue: dataValue) {
                self.downloadedContents[answer.id!] = answer
                DispatchQueue.main.async {
                    completion()
                }
            }
        }) { (error) in
            print("Failed to cast vote to answer. Error is \(error.localizedDescription)")
            DispatchQueue.main.async {
                errorHandler()
            }
        }
    }
    
}


