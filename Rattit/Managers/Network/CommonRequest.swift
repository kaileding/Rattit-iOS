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
    var HTTPHeaders: [String: String]? = nil
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
}

