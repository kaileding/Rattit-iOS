//
//  MomentManager.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import Alamofire

class MomentManager: NSObject {
    static var downloadedMoments: [Moment] = []
    static var lastRefreshTime: Date? = nil
    
    static func getLatestMoments(completion: @escaping () -> ()) {
        
        request(RATTIT_CONTENT_SERVICE_HOST+RATTIT_CONTENT_SERVICE_VERSION+"/moments",
                method: .get,
                parameters: nil,
                encoding: URLEncoding.default,
                headers: nil)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON(queue: utilityQueue, options: .mutableContainers, completionHandler: { (dataResponse) in
                
                switch dataResponse.result {
                case .success(let value):
                    if let responseBody = value as? [String: Any], let count = responseBody["count"] as? Int, let rows = responseBody["rows"] as? [Any] {
                        
                        print("Got \(count) moments from server.")
                        rows.forEach({ (dataValue) in
                            if let moment = Moment(dataValue: dataValue) {
                                MomentManager.downloadedMoments.append(moment)
                            }
                        })
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                    
                case .failure(let error):
                    print("HTTP Call got failure: \(error.localizedDescription)")
                }
                
            })
    }
    
}
