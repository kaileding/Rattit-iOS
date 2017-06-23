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
                    errorHandler(RattitError(message: "Unable to create UIImage from data."))
                }
                
            }, errorHandler: { (error) in
                errorHandler(error)
            })
        }
    }
}
