//
//  Network.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import Alamofire

class Network {
    
    static let sharedInstance: Network = Network()
    
    func callRattitContentService(httpRequest: CommonRequest, completion: @escaping (Any) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        request(httpRequest.baseUrl+httpRequest.urlPath,
                method: httpRequest.method,
                parameters: httpRequest.parameters,
                encoding: URLEncoding.queryString,
                headers: httpRequest.HTTPHeaders)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON(queue: utilityQueue, options: .mutableContainers) { (jsonResponse) in
                
                print("===== The Request is: ", jsonResponse.request?.description ?? "nil")
                
                switch jsonResponse.result {
                case .success(let value):
                    
                    completion(value)
                    
                case .failure(let error):
                    print("===== HTTP Call got failure: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        errorHandler(error)
                    }
                }
        }
    }
    
    func callS3ToLoadImage(imageUrl: String, completion: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        request(imageUrl).validate(statusCode: 200..<300).responseData(queue: utilityQueue) { (dataResponse) in
            
            print("===== The Image URL is: ", dataResponse.request?.description ?? "nil")
            
            switch dataResponse.result {
            case .success(let value):
                DispatchQueue.main.async {
                    completion(value)
                }
            case .failure(let error):
                print("===== Image Loading got failure: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    errorHandler(error)
                }
            }
        }
        
    }
    
}
