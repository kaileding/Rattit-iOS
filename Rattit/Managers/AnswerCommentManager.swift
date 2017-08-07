//
//  AnswerCommentManager.swift
//  Rattit
//
//  Created by DINGKaile on 8/2/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

class AnswerCommentManager: BaseContentManager<CommentForAnswer> {
    
    var dialogDisplaySequence: [String] = []
    var newCommentWords: String? = nil
    
    static let sharedInstance: MomentCommentManager = MomentCommentManager()
    
    func loadCommentsOfAnAnswerFromServer(answerId: String, completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getAllContentsRequest = CommonRequest.getCommentsForAnAnswer(answerId: answerId)
        self.displaySequenceOfContents.removeAll()
        self.lastContentCreatedAt = nil
        self.lastContentId = nil
        self.firstContentCreatedAt = nil
        self.firstContentId = nil
        self.lastRefreshTime = nil
        self.loadContentsFromServer(completion: { (dataBody) in
            completion()
        }, errorHandler: errorHandler)
    }
    
    func loadMoreCommentsOfAnAnswerFromServer(answerId: String, completion: @escaping (Bool) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getAllContentsRequest = CommonRequest.getCommentsForAnAnswer(answerId: answerId)
        if self.lastContentCreatedAt == nil {
            self.getContentsNoEarlierThanRequest = CommonRequest.getCommentsForAnAnswer(answerId: answerId)
        } else {
            self.getContentsNoEarlierThanRequest = CommonRequest.getCommentsForAnAnswerNoLaterThan(answerId: answerId, commentId: nil, timeThreshold: self.lastContentCreatedAt!.dateToUtcString)
        }
        
        self.loadContentsUpdatesFromServer(completion: completion, errorHandler: errorHandler)
    }
    
    func getCommentsOfAnswerCreatedByAUser(userId: String, completion: @escaping ([String]) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getContentsCreatedByUserRequest = CommonRequest.getCommentsOfAnswerCreatedByUser(userId: userId)
        self.getContentsCreatedByAUser(completion: completion, errorHandler: errorHandler)
    }
    
    func postNewCommentToAnAnswer(answerId: String, commentId: String?, completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if self.newCommentWords != nil {
            
            print("postNewCommentToAnAnswer, words=\(self.newCommentWords!)")
            
            var newCommentDic = [String: Any]()
            newCommentDic["for_answer"] = answerId as Any
            if commentId != nil {
                newCommentDic["for_comment"] = commentId! as Any
            }
            newCommentDic["words"] = self.newCommentWords! as Any
            newCommentDic["hash_tags"] = ["iPhoneTesting"] as Any
            
            Network.shared.callContentAPI(httpRequest: .postNewCommentToAnAnswer(bodyDic: newCommentDic), completion: { (dataValue) in
                print("successfully published new comment to an answer.")
                
                DispatchQueue.main.async {
                    completion()
                }
                
            }, errorHandler: { (error) in
                print("publishing new comment to an answer failed: \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    errorHandler(error)
                }
            })
        }
    }
    
    func castVoteToAnAnswerComment(answerCommentId: String, voteType: RattitAnswerCommentVoteType, commit: Bool, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
        Network.shared.callContentAPI(httpRequest: .castVoteToACommentOfAnAnswer(commentId: answerCommentId, voteType: voteType, commit: commit), completion: { (dataValue) in
            
            if let answerComment = CommentForAnswer(dataValue: dataValue) {
                self.downloadedContents[answerComment.id!] = answerComment
                DispatchQueue.main.async {
                    completion()
                }
            }
        }) { (error) in
            print("Failed to cast vote to a comment of an answer. Error is \(error.localizedDescription)")
            DispatchQueue.main.async {
                errorHandler()
            }
        }
    }
    
}

