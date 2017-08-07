//
//  MomentCommentManager.swift
//  Rattit
//
//  Created by DINGKaile on 8/2/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class MomentCommentManager: BaseContentManager<CommentForMoment> {
    
    var dialogDisplaySequence: [String] = []
    var newCommentWords: String? = nil
    var newCommentAttachedPhoto: UIImage? = nil
    
    static let sharedInstance: MomentCommentManager = MomentCommentManager()
    
    func loadCommentsOfAMomentFromServer(momentId: String, completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getAllContentsRequest = CommonRequest.getCommentsForAMoment(momentId: momentId)
        self.displaySequenceOfContents.removeAll()
        self.lastContentCreatedAt = nil
        self.lastContentId = nil
        self.firstContentCreatedAt = nil
        self.firstContentId = nil
        self.lastRefreshTime = nil
        self.dialogDisplaySequence.removeAll()
        self.loadContentsFromServer(completion: { (dataBody) in
            if let dialogIds = dataBody["dialog_format_ids"] as? [String: [String]] {
                let rootCommentIds = Array(dialogIds.keys).sorted(by: { (left, right) -> Bool in
                    return left > right
                })
                rootCommentIds.forEach({ (rootCommentId) in
                    self.dialogDisplaySequence.append(rootCommentId)
                    self.dialogDisplaySequence.append(contentsOf: dialogIds[rootCommentId]!)
                })
            }
            completion()
        }, errorHandler: errorHandler)
    }
    
    func loadMoreCommentsOfAMomentFromServer(momentId: String, completion: @escaping (Bool) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getAllContentsRequest = CommonRequest.getCommentsForAMoment(momentId: momentId)
        if self.lastContentCreatedAt == nil {
            self.getContentsNoEarlierThanRequest = CommonRequest.getCommentsForAMoment(momentId: momentId)
        } else {
            self.getContentsNoEarlierThanRequest = CommonRequest.getCommentsForAMomentNoLaterThan(momentId: momentId, commentId: nil, timeThreshold: self.lastContentCreatedAt!.dateToUtcString)
        }
        
        self.loadContentsUpdatesFromServer(completion: completion, errorHandler: errorHandler)
    }
    
    func getCommentsOfMomentCreatedByAUser(userId: String, completion: @escaping ([String]) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.getContentsCreatedByUserRequest = CommonRequest.getCommentsOfMomentCreatedByUser(userId: userId)
        self.getContentsCreatedByAUser(completion: completion, errorHandler: errorHandler)
    }
    
    func postNewCommentToAMoment(momentId: String, commentId: String?, completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if self.newCommentWords != nil {
            
            print("postNewCommentToAMoment, words=\(self.newCommentWords!)")
            
            var newCommentDic = [String: Any]()
            newCommentDic["for_moment"] = momentId as Any
            if commentId != nil {
                newCommentDic["for_comment"] = commentId! as Any
            }
            newCommentDic["words"] = self.newCommentWords! as Any
            newCommentDic["hash_tags"] = ["iPhoneTesting"] as Any
            
            if let imageChosen = self.newCommentAttachedPhoto {
                ComposeContentManager.uploadOneImageToServer(rawImage: imageChosen, gotImageUrl: { (imageUrl) in
                    
                    newCommentDic["photos"] = [["image_url": imageUrl,
                                                "height": 500,
                                                "width": 500]] as Any
                    Network.shared.callContentAPI(httpRequest: .postNewCommentToAMoment(bodyDic: newCommentDic), completion: { (dataValue) in
                        print("successfully published new comment to a moment.")
                        
                        DispatchQueue.main.async {
                            completion()
                        }
                        
                    }, errorHandler: { (error) in
                        print("publishing new comment to a moment failed: \(error.localizedDescription)")
                        
                        DispatchQueue.main.async {
                            errorHandler(error)
                        }
                    })
                })
            }
        }
    }
    
    func castVoteToAMomentComment(momentCommentId: String, voteType: RattitMomentCommentVoteType, commit: Bool, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        
        Network.shared.callContentAPI(httpRequest: .castVoteToACommentOfAMoment(commentId: momentCommentId, voteType: voteType, commit: commit), completion: { (dataValue) in
            
            if let momentComment = CommentForMoment(dataValue: dataValue) {
                self.downloadedContents[momentComment.id!] = momentComment
                DispatchQueue.main.async {
                    completion()
                }
            }
        }) { (error) in
            print("Failed to cast vote to comment of a moment. Error is \(error.localizedDescription)")
            DispatchQueue.main.async {
                errorHandler()
            }
        }
    }
    
}
