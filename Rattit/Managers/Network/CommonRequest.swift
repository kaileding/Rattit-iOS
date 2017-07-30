//
//  CommonRequest.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import Alamofire

struct CommonRequest {
    let baseUrl: String = RATTIT_CONTENT_SERVICE_HOST+RATTIT_CONTENT_SERVICE_VERSION
    var urlPath: String!
    var method: HTTPMethod!
    var parameters: [String: Any]? = nil
    var endcoding: ParameterEncoding = URLEncoding.queryString
    var HTTPHeaders: [String: String] = ["Content-Type": "application/json"]
    var absoluteUrl: String {
        get {
            return (self.baseUrl + self.urlPath)
        }
    }
    
    init(urlPath: String, method: HTTPMethod) {
        self.urlPath = urlPath
        self.method = method
    }
    
    // get All moments from content_service
    static var GetMoments: CommonRequest {
        return CommonRequest(urlPath: "/moments", method: .get)
    }
    
    // get All questions from content_service
    static var GetQuestions: CommonRequest {
        return CommonRequest(urlPath: "/questions", method: .get)
    }
    
    // get All answers from content_service
    static var GetAnswers: CommonRequest {
        return CommonRequest(urlPath: "/answers", method: .get)
    }
    
    // get moments published later than some time
    static func getMomentsNoEarlierThan(timeThreshold: String) -> CommonRequest {
        var getMomentsNoEarlierThanRequest = CommonRequest(urlPath: "/moments", method: .get)
        getMomentsNoEarlierThanRequest.parameters = ["date_query_type": "noearlier_than",
                                                 "date_query_line": timeThreshold]
        return getMomentsNoEarlierThanRequest
    }
    
    // get moments published earlier than some time
    static func getMomentsNoLaterThan(timeThreshold: String) -> CommonRequest {
        var getMomentsNoLaterThanRequest = CommonRequest(urlPath: "/moments", method: .get)
        getMomentsNoLaterThanRequest.parameters = ["date_query_type": "nolater_than",
                                                   "date_query_line": timeThreshold]
        return getMomentsNoLaterThanRequest
    }
    
    // get questions published later than some time
    static func getQuestionsNoEarlierThan(timeThreshold: String) -> CommonRequest {
        var getQuestionsNoEarlierThanRequest = CommonRequest(urlPath: "/questions", method: .get)
        getQuestionsNoEarlierThanRequest.parameters = ["date_query_type": "noearlier_than",
                                                     "date_query_line": timeThreshold]
        return getQuestionsNoEarlierThanRequest
    }
    
    // get questions published earlier than some time
    static func getQuestionsNoLaterThan(timeThreshold: String) -> CommonRequest {
        var getQuestionsNoLaterThanRequest = CommonRequest(urlPath: "/questions", method: .get)
        getQuestionsNoLaterThanRequest.parameters = ["date_query_type": "nolater_than",
                                                   "date_query_line": timeThreshold]
        return getQuestionsNoLaterThanRequest
    }
    
    // get answers published later than some time
    static func getAnswersNoEarlierThan(timeThreshold: String) -> CommonRequest {
        var getAnswersNoEarlierThanRequest = CommonRequest(urlPath: "/answers", method: .get)
        getAnswersNoEarlierThanRequest.parameters = ["date_query_type": "noearlier_than",
                                                       "date_query_line": timeThreshold]
        return getAnswersNoEarlierThanRequest
    }
    
    // get answers published earlier than some time
    static func getAnswersNoLaterThan(timeThreshold: String) -> CommonRequest {
        var getAnswersNoLaterThanRequest = CommonRequest(urlPath: "/answers", method: .get)
        getAnswersNoLaterThanRequest.parameters = ["date_query_type": "nolater_than",
                                                     "date_query_line": timeThreshold]
        return getAnswersNoLaterThanRequest
    }
    
    // get moments created by a user
    static func getMomentsCreatedByUser(userId: String) -> CommonRequest {
        var getMomentsCreatedByUserRequest = CommonRequest(urlPath: "/moments", method: .get)
        getMomentsCreatedByUserRequest.parameters = ["author_id": userId]
        return getMomentsCreatedByUserRequest
    }
    
    // get questions created by a user
    static func getQuestionsCreatedByUser(userId: String) -> CommonRequest {
        var getQuestionsCreatedByUserRequest = CommonRequest(urlPath: "/questions", method: .get)
        getQuestionsCreatedByUserRequest.parameters = ["author_id": userId]
        return getQuestionsCreatedByUserRequest
    }
    
    // get answers created by a user
    static func getAnswersCreatedByUser(userId: String) -> CommonRequest {
        var getAnswersCreatedByUserRequest = CommonRequest(urlPath: "/answers", method: .get)
        getAnswersCreatedByUserRequest.parameters = ["author_id": userId]
        return getAnswersCreatedByUserRequest
    }
    
    // get All Rattit users from server
    static var GetUsers: CommonRequest {
        return CommonRequest(urlPath: "/users", method: .get)
    }
    
    // get details of an user by its ID
    static func getUserWithId(id: String) -> CommonRequest {
        return CommonRequest(urlPath: "/users/\(id)", method: .get)
    }
    
    // get signed AWS-S3 request to upload Image
    static func getSignedURLToUploadImage(filename: String, fileType: String) -> CommonRequest {
        var getSignedURLToUploadImageRequest = CommonRequest(urlPath: "/utilities/s3/signedurl", method: .get)
        getSignedURLToUploadImageRequest.parameters = ["filename": filename,
                                                       "filetype": fileType]
        return getSignedURLToUploadImageRequest
    }
    
    // get nearby places from google API
    static func getNearbyPlacesFromGoogle(latitude: Double, longitude: Double, withinDistance: Double, type: String) -> CommonRequest {
        var getNearbyPlacesFromGoogleRequest = CommonRequest(urlPath: "/locations/nearby", method: .get)
        getNearbyPlacesFromGoogleRequest.parameters = ["lat": latitude,
                                                       "lon": longitude,
                                                       "radius": withinDistance,
                                                       "typename": type]
        return getNearbyPlacesFromGoogleRequest
    }
    
    // post new moment content
    static func postNewMomentContent(bodyDic: [String: Any]) -> CommonRequest {
        var postNewMomentContentRequest = CommonRequest(urlPath: "/moments", method: .post)
        postNewMomentContentRequest.parameters = bodyDic
        postNewMomentContentRequest.endcoding = JSONEncoding.default
        postNewMomentContentRequest.HTTPHeaders["user_id"] = UserStateManager.sharedInstance.dummyUserId
        return postNewMomentContentRequest
    }
    
    // post new answert to a question
    static func postNewAnswerToQuestion(bodyDic: [String: Any]) -> CommonRequest {
        var postNewAnswerToQuestionRequest = CommonRequest(urlPath: "/answers", method: .post)
        postNewAnswerToQuestionRequest.parameters = bodyDic
        postNewAnswerToQuestionRequest.endcoding = JSONEncoding.default
        postNewAnswerToQuestionRequest.HTTPHeaders["user_id"] = UserStateManager.sharedInstance.dummyUserId
        return postNewAnswerToQuestionRequest
    }
    
    // post new question content
    static func postNewQuestionContent(bodyDic: [String: Any]) -> CommonRequest {
        var postNewQuestionContentRequest = CommonRequest(urlPath: "/questions", method: .post)
        postNewQuestionContentRequest.parameters = bodyDic
        postNewQuestionContentRequest.endcoding = JSONEncoding.default
        postNewQuestionContentRequest.HTTPHeaders["user_id"] = UserStateManager.sharedInstance.dummyUserId
        return postNewQuestionContentRequest
    }
    
    // cast a vote to a certain moment
    static func castVoteToAMoment(momentId: String, voteType: RattitMomentVoteType, commit: Bool) -> CommonRequest {
        var castVoteToAMomentRequest = CommonRequest(urlPath: "/moments/\(momentId)/voters/\(UserStateManager.sharedInstance.dummyUserId)", method: .patch)
        castVoteToAMomentRequest.parameters = ["type": voteType.rawValue,
                                               "commit": commit]
        castVoteToAMomentRequest.endcoding = JSONEncoding.default
        return castVoteToAMomentRequest
    }
    
    // cast a vote to a certain question
    static func castVoteToAQuestion(questionId: String, voteType: RattitQuestionVoteType, commit: Bool) -> CommonRequest {
        var castVoteToAQuestionRequest = CommonRequest(urlPath: "/questions/\(questionId)/voters/\(UserStateManager.sharedInstance.dummyUserId)", method: .patch)
        castVoteToAQuestionRequest.parameters = ["type": voteType.rawValue,
                                               "commit": commit]
        castVoteToAQuestionRequest.endcoding = JSONEncoding.default
        return castVoteToAQuestionRequest
    }
    
    // cast a vote to a certain answer
    static func castVoteToAnAnswer(answerId: String, voteType: RattitAnswerVoteType, commit: Bool) -> CommonRequest {
        var castVoteToAnAnswerRequest = CommonRequest(urlPath: "/answers/\(answerId)/voters/\(UserStateManager.sharedInstance.dummyUserId)", method: .patch)
        castVoteToAnAnswerRequest.parameters = ["type": voteType.rawValue,
                                               "commit": commit]
        castVoteToAnAnswerRequest.endcoding = JSONEncoding.default
        return castVoteToAnAnswerRequest
    }
    
    // get followers of a user
    static func getFollowersOfAUser(userId: String) -> CommonRequest {
        return CommonRequest(urlPath: "/users/\(userId)/followers", method: .get)
    }
    
    // get followees of a user
    static func getFolloweesOfAUser(userId: String) -> CommonRequest {
        return CommonRequest(urlPath: "/users/\(userId)/followees", method: .get)
    }
    
    // get friends of a user
    static func getFriendsOfAUser(userId: String) -> CommonRequest {
        return CommonRequest(urlPath: "/users/\(userId)/friends", method: .get)
    }
    
    // follow users
    static func followUsers(targetUserIds: [String], byUser: String) -> CommonRequest {
        var followUsersRequest = CommonRequest(urlPath: "/users/\(byUser)/followees", method: .post)
        followUsersRequest.parameters = ["followees": targetUserIds]
        followUsersRequest.endcoding = JSONEncoding.default
        
        return followUsersRequest
    }
    
    // unfollow a user
    static func unfollowAUser(targetUserId: String, byUser: String) -> CommonRequest {
        return CommonRequest(urlPath: "/users/\(byUser)/followees/\(targetUserId)", method: .delete)
    }
    
}

