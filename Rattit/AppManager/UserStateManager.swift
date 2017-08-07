//
//  UserStateManager.swift
//  Rattit
//
//  Created by DINGKaile on 6/17/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

class UserStateManager: NSObject {
    static var userIsLoggedIn: Bool = false
    static var userRefusedToLogin: Bool = true
    static var showingSignInAlert: Bool = false
    static var initialContentLoaded: Bool = false
    static var devicePhotoLibraryLoaded: Bool = false
    
    var dummyUserId: String = "e5b89946-4db4-11e7-b114-b2f933d5fe66"
    var dummyUser: RattitUser? = nil
    var dummyMyFollowers: [String] = [] // array of userIds
    var dummyMyFollowees: [String] = [] // array of userIds
    var dummyMyFriends: [String] = [] // array of userIds
    
    var dummyMyMoments: [String] = [] // array of momentIds
    var dummyMyVotesToMoments: [String: [VoteForMoment]] = [:] // momentId: [VoteForMoment]
    var dummyMyQuestions: [String] = [] // array of questionIds
    var dummyMyVotesToQuestions: [String: [VoteForQuestion]] = [:] // questionId: [VoteForQuestion]
    var dummyMyAnswers: [String] = [] // array of answerIds
    var dummyMyVotesToAnswers: [String: [VoteForAnswer]] = [:] // answerId: [VoteForAnswer]
    
    var dummyUserInfoLoadMap: UInt32 = 0
    var dummyUserInfoLoaded: Bool {
        get {
            return (self.dummyUserInfoLoadMap == 1023)
        }
    }
    
    static let sharedInstance: UserStateManager = UserStateManager()
    
    func loadMyCurrentInformation() {
        
        RattitUserManager.sharedInstance.getRattitUserForId(id: self.dummyUserId, completion: { (rattitUser) in
            
            UserStateManager.sharedInstance.dummyUser = rattitUser
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 1
        }) { (error) in
            print("== Unable to load user for id = \(self.dummyUserId) as myself. \(error.localizedDescription)")
        }
        
        RattitUserManager.sharedInstance.getFollowersOrFolloweesOfUser(userId: self.dummyUserId, relationType: .follower, completion: { (totalNum, userGroup) in
            
            self.dummyMyFollowers = userGroup
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 2
        }) { (error) in
            print("== Unable to load followers of mine. \(error.localizedDescription)")
        }
        
        RattitUserManager.sharedInstance.getFollowersOrFolloweesOfUser(userId: self.dummyUserId, relationType: .followee, completion: { (totalNum, userGroup) in
            
            self.dummyMyFollowees = userGroup
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 4
        }) { (error) in
            print("== Unable to load followees of mine. \(error.localizedDescription)")
        }
        
        RattitUserManager.sharedInstance.getFollowersOrFolloweesOfUser(userId: self.dummyUserId, relationType: .friends, completion: { (totalNum, userGroup) in
            
            self.dummyMyFriends = userGroup
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 8
        }) { (error) in
            print("== Unable to load friends of mine. \(error.localizedDescription)")
        }
        
        MomentManager.sharedInstance.getMomentsCreatedByAUser(userId: self.dummyUserId, completion: { (momentGroup) in
            
            self.dummyMyMoments = momentGroup
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 16
        }) { (error) in
            print("== Unable to load moments of mine. \(error.localizedDescription)")
        }
        
        QuestionManager.sharedInstance.getQuestionsCreatedByAUser(userId: self.dummyUserId, completion: { (questionGroup) in
            
            self.dummyMyQuestions = questionGroup
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 32
        }) { (error) in
            print("== Unable to load questions of mine. \(error.localizedDescription)")
        }
        
        AnswerManager.sharedInstance.getAnswersCreatedByAUser(userId: self.dummyUserId, completion: { (answerGroup) in
            
            self.dummyMyAnswers = answerGroup
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 64
        }) { (error) in
            print("== Unable to load answers of mine. \(error.localizedDescription)")
        }
        
        MomentManager.sharedInstance.getVotesToMomentCreatedByAUser(userId: self.dummyUserId, completion: { (votesForMoments) in
            
            self.dummyMyVotesToMoments.removeAll()
            votesForMoments.forEach({ (voteForMoments) in
                if self.dummyMyVotesToMoments[voteForMoments.momentId] != nil {
                    self.dummyMyVotesToMoments[voteForMoments.momentId]!.append(voteForMoments)
                } else {
                    self.dummyMyVotesToMoments[voteForMoments.momentId] = [voteForMoments]
                }
            })
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 128
            
        }) { (error) in
            print("== Unable to load votes to moments of mine. \(error.localizedDescription)")
        }
        
        QuestionManager.sharedInstance.getVotesToQuestionCreatedByAUser(userId: self.dummyUserId, completion: { (votesForQuestions) in
            
            self.dummyMyVotesToQuestions.removeAll()
            votesForQuestions.forEach({ (voteForQuestions) in
                if self.dummyMyVotesToQuestions[voteForQuestions.questionId] != nil {
                    self.dummyMyVotesToQuestions[voteForQuestions.questionId]!.append(voteForQuestions)
                } else {
                    self.dummyMyVotesToQuestions[voteForQuestions.questionId] = [voteForQuestions]
                }
            })
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 256
            
        }) { (error) in
            print("== Unable to load votes to questions of mine. \(error.localizedDescription)")
        }
        
        AnswerManager.sharedInstance.getVotesToAnswerCreatedByAUser(userId: self.dummyUserId, completion: { (votesForAnswers) in
            
            self.dummyMyVotesToAnswers.removeAll()
            votesForAnswers.forEach({ (voteForAnswers) in
                if self.dummyMyVotesToAnswers[voteForAnswers.answerId] != nil {
                    self.dummyMyVotesToAnswers[voteForAnswers.answerId]!.append(voteForAnswers)
                } else {
                    self.dummyMyVotesToAnswers[voteForAnswers.answerId] = [voteForAnswers]
                }
            })
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 512
            
        }) { (error) in
            print("== Unable to load votes to answers of mine. \(error.localizedDescription)")
        }
        
    }
    
}
