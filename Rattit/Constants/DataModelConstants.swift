//
//  DataModelConstants.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

public enum RattitUserGender: String {
    case male = "male"
    case female = "female"
    case untold = "untold"
}

public enum RattitContentAccessLevel: String {
    case levelSelf = "self"
    case levelFriends = "friends"
    case levelFollowers = "followers"
    case levelPublic = "public"
}

public enum RattitContentType: String {
    case moment = "moment"
    case question = "question"
    case answer = "answer"
    case momentComment = "momentComment"
    case answerComment = "answerComment"
}

public enum RattitMomentVoteType: String {
    case typeLike = "like"
    case typeAdmire = "admire"
    case typePity = "pity"
}

public enum RattitQuestionVoteType: String {
    case typeInterest = "interest"
    case typeInvite = "invite"
    case typePity = "pity"
}

public enum RattitAnswerVoteType: String {
    case typeAgree = "agree"
    case typeDisagree = "disagree"
    case typeAdmire = "admire"
}

public enum RattitMomentCommentVoteType: String {
    case like = "like"
    case dislike = "dislike"
}

public enum RattitAnswerCommentVoteType: String {
    case like = "like"
}

public enum RattitUserRelationshipType: String {
    case followee = "followee"
    case follower = "follower"
    case friends = "friends"
}

