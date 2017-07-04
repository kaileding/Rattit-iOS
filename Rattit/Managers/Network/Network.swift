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
                encoding: httpRequest.endcoding,
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
    
    func callS3ToUploadFile(signedRequest: String, fileData: Data, fileType: String, completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        upload(fileData,
               to: signedRequest,
               method: .put,
               headers: ["Content-Type": fileType])
            .uploadProgress(queue: utilityQueue,
                            closure: { (progress) in
                                
//                                print("upload progress: \(progress.fractionCompleted*100.0)%")
                                
        }).responseJSON { (jsonResponse) in
            
            if let statusCode = jsonResponse.response?.statusCode, statusCode == 200 {
                print("ok. upload done.")
                completion()
            } else {
                DispatchQueue.main.async {
                    errorHandler(RattitError.netWorkError(message: "upload to S3 got error response."))
                }
            }
        }
    }
    
}
