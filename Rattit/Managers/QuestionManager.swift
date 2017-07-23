//
//  QuestionManager.swift
//  Rattit
//
//  Created by DINGKaile on 7/22/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import Alamofire

class QuestionManager: BaseContentManager<Question> {
    
    static let sharedInstance: QuestionManager = QuestionManager()
    
    func loadQuestionsFromServer(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getAllContentsRequest = CommonRequest.GetQuestions
        self.loadContentsFromServer(completion: completion, errorHandler: errorHandler)
    }
    
    func loadQuestionsUpdatesFromServer(completion: @escaping (Bool) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getAllContentsRequest = CommonRequest.GetQuestions
        if self.lastContentCreatedAt == nil {
            self.getContentsNoEarlierThanRequest = CommonRequest.GetQuestions
        } else {
            self.getContentsNoEarlierThanRequest = CommonRequest.getQuestionsNoEarlierThan(timeThreshold: self.lastContentCreatedAt!.dateToUtcString)
        }
        
        self.loadContentsUpdatesFromServer(completion: completion, errorHandler: errorHandler)
    }
    
    func getQuestionsCreatedByAUser(userId: String, completion: @escaping ([String]) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getContentsCreatedByUserRequest = CommonRequest.getQuestionsCreatedByUser(userId: userId)
        self.getContentsCreatedByAUser(completion: completion, errorHandler: errorHandler)
    }
    
    func castVoteToAQuestion(questionId: String, voteType: RattitQuestionVoteType, commit: Bool, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
        Network.sharedInstance.callRattitContentService(httpRequest: .castVoteToAQuestion(questionId: questionId, voteType: voteType, commit: commit), completion: { (dataValue) in
            
            if let question = Question(dataValue: dataValue) {
                self.downloadedContents[question.id!] = question
                DispatchQueue.main.async {
                    completion()
                }
            }
        }) { (error) in
            print("Failed to cast vote to question. Error is \(error.localizedDescription)")
            DispatchQueue.main.async {
                errorHandler()
            }
        }
    }
    
}
