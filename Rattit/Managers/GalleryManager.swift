//
//  GalleryManager.swift
//  Rattit
//
//  Created by DINGKaile on 6/22/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import UIKit

class GalleryManager: NSObject {
    static var cachedImages: [String: UIImage] = [:] // url: UIImage
    
    static var networkService: Network = Network()
    
    static func getImageFromUrl(imageUrl: String, completion: @escaping (UIImage) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if let foundImage = GalleryManager.cachedImages[imageUrl] {
            completion(foundImage)
        } else {
            GalleryManager.networkService.callS3ToLoadImage(imageUrl: imageUrl, completion: { (imageData) in
                
                if let loadedmage = UIImage(data: imageData) {
                    GalleryManager.cachedImages[imageUrl] = loadedmage
                    completion(loadedmage)
                } else {
                    errorHandler(RattitError.parseError(message: "Unable to create UIImage from data."))
                }
                
            }, errorHandler: { (error) in
                errorHandler(error)
            })
        }
    }
    
    static func uploadImageToS3(imageName: String, image: UIImage, gotImageUrl: @escaping (String) -> Void, completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if let imageData = UIImageJPEGRepresentation(image, 0.7) {
            GalleryManager.networkService.callContentAPI(httpRequest: .getSignedURLToUploadImage(filename: imageName+".jpeg", fileType: "jpeg"), completion: { (dataValue) in
                
                if let responseBody = dataValue as? [String: String], let signedRequest = responseBody["signedRequestUrl"], let publicUrl = responseBody["publicUrl"] {
                    
                    gotImageUrl(publicUrl)
                    
                    GalleryManager.networkService.callS3ToUploadFile(signedRequest: signedRequest, fileData: imageData, fileType: "jpeg", completion: {
                        
                        GalleryManager.cachedImages[publicUrl] = image
                        completion()
                    }, errorHandler: { (error) in
                        errorHandler(error)
                    })
                }
                
            }) { (error) in
                errorHandler(error)
            }
        } else {
            errorHandler(RattitError.parseError(message: "Unable to get data from UIImage by UIImageJPEGRepresentation."))
        }
        
        
    }
}
