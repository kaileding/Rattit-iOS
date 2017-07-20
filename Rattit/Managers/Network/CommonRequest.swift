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
    
    // get moments created by a user
    static func getMomentsCreatedByUser(userId: String) -> CommonRequest {
        var getMomentsCreatedByUserRequest = CommonRequest(urlPath: "/moments", method: .get)
        getMomentsCreatedByUserRequest.parameters = ["author_id": userId]
        return getMomentsCreatedByUserRequest
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
    
    // cast a vote to a certain moment
    static func castVoteToAMoment(momentId: String, voteType: RattitMomentVoteType, commit: Bool) -> CommonRequest {
        var castVoteToAMomentRequest = CommonRequest(urlPath: "/moments/\(momentId)/voters/\(UserStateManager.sharedInstance.dummyUserId)", method: .patch)
        castVoteToAMomentRequest.parameters = ["type": voteType.rawValue,
                                               "commit": commit]
        castVoteToAMomentRequest.endcoding = JSONEncoding.default
        return castVoteToAMomentRequest
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
    
}

