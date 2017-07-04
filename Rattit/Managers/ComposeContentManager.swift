//
//  ComposeContentManager.swift
//  Rattit
//
//  Created by DINGKaile on 6/27/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import Photos

class ComposeContentManager {
    
    var photoAssetsOnDivece: PHFetchResult<PHAsset>? = nil
    var imageOfPhotosOnDevice: [UIImage] = []
    var indexOfCheckedPhotos: [Int] = []
    var publicUrlsOfCheckedPhotos: [[String: Any]] = []
    var updateSelectedPhotoDelegate: ComposeContentUpdateSelectedPhotosDelegate? = nil
    var updateSelectedUsersDelegate: ComposeContentUpdateSelectedUsersDelegate? = nil
    
    var pickedPlaceFromGoogle: GoogleLocation? = nil
    var pickedPlaceRatingValue: Int = 0
    var pickedUsersForTogether: [String] = [] // RattitUser ids
    var uiviewOfPickedUsersForTogether: [PickedUserTogetherWithView] = [] // showing on FindTogetherWithViewController
    var imagesOfPickedUsersForTogether: [UIImageView] = [] // showing on ComposeTextTableViewController
    
    var shareToLevel: RattitContentAccessLevel = .levelPublic
    
    static let sharedInstance: ComposeContentManager = ComposeContentManager()
    
    func getPhotoAsset(forCell index: Int) -> PHAsset? {
        if self.photoAssetsOnDivece == nil {
            return nil
        } else {
            return self.photoAssetsOnDivece!.object(at: index)
        }
    }
    
    func getCheckIndexValue(forCell index: Int) -> Int {
        if let indexVal = self.indexOfCheckedPhotos.index(of: index) {
            return (indexVal + 1)
        } else {
            return 0
        }
    }
    
    func checkAPhoto(atCell index: Int) {
        if !self.indexOfCheckedPhotos.contains(index) {
            self.indexOfCheckedPhotos.append(index)
        }
    }
    
    func uncheckAPhoto(atCell index: Int) {
        if let indexVal = self.indexOfCheckedPhotos.index(of: index) {
            self.indexOfCheckedPhotos.remove(at: indexVal)
        }
    }
    
    func updateAllPhotoCells() {
        self.updateSelectedPhotoDelegate?.updatePhotoCollectionCells()
    }
    
    func insertNewPhotoToCollection(newImage: UIImage) {
        self.imageOfPhotosOnDevice.insert(newImage, at: 0)
        self.indexOfCheckedPhotos = self.indexOfCheckedPhotos.map { (val) -> Int in
            return (val+1)
        }
        self.indexOfCheckedPhotos.append(0)
        self.updateSelectedPhotoDelegate?.updatePhotoCollectionCells()
    }
    
    func hasAtLeastOneImageChecked() -> Bool {
        return (self.indexOfCheckedPhotos.count > 0)
    }
    
    func initializePhotoLibrary() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.photoAssetsOnDivece = PHAsset.fetchAssets(with: fetchOptions)
        
        let targetImageSize = CGSize(width: 0.5*320.0, height: 0.5*320.0)
        self.photoAssetsOnDivece?.enumerateObjects({ (pHAsset, index, pointer) in
            
            let parsedImage = ComposeContentManager.phAssetToUIImage(asset: pHAsset, dimension: targetImageSize)
            self.imageOfPhotosOnDevice.append(parsedImage)
            
        })
        print("Successfully got ", self.photoAssetsOnDivece!.count, "Image assets. ")
    }
    
    func getSelectedImages() -> [UIImage] {
        var resImags: [UIImage] = []
        self.indexOfCheckedPhotos.forEach { (index) in
            resImags.append(self.imageOfPhotosOnDevice[index])
        }
        return resImags
    }
    
    func removeUserFromSelectedGroup(userId: String) {
        if let indexVal = self.pickedUsersForTogether.index(of: userId) {
            self.pickedUsersForTogether.remove(at: indexVal)
            self.updateSelectedUsersDelegate?.updateSelectedGroup()
        }
    }
    
    func insertNewUserToSelectedGroup(userId: String) {
        if !self.pickedUsersForTogether.contains(userId) {
            self.pickedUsersForTogether.append(userId)
            self.updateSelectedUsersDelegate?.updateSelectedGroup()
        }
    }
    
    func postNewMoment(title: String, words: String) {
        print("postNewMoment, title=\(title), words=\(words)")
        
        var newMomentDic = [String: Any]()
        newMomentDic["title"] = title as Any
        newMomentDic["words"] = words as Any
        newMomentDic["access_level"] = self.shareToLevel.rawValue as Any
        newMomentDic["together_with"] = self.pickedUsersForTogether as Any
        newMomentDic["hash_tags"] = ["iPhoneTesting"] as Any
        
        if self.pickedPlaceFromGoogle != nil {
            newMomentDic["google_place"] = self.pickedPlaceFromGoogle!.wrapIntoLocationPostObj() as Any
        }
        
        self.publicUrlsOfCheckedPhotos.removeAll()
        let numberOfCheckedPhotos = self.indexOfCheckedPhotos.count
        let stubPublicUrlObj: [String: Any] = ["image_url": "",
                                               "height": 500,
                                               "width": 500]
        self.publicUrlsOfCheckedPhotos = Array(repeating: stubPublicUrlObj, count: numberOfCheckedPhotos)
        self.indexOfCheckedPhotos.enumerated().forEach({ (offset, indexVal) in
            let imageChosen = self.imageOfPhotosOnDevice[indexVal]
            ComposeContentManager.uploadOneImageToServer(rawImage: imageChosen, gotImageUrl: { (imageUrl) in
                
                self.publicUrlsOfCheckedPhotos[offset]["image_url"] = imageUrl
                if !self.publicUrlsOfCheckedPhotos.contains(where: { (publicUrlObj) -> Bool in
                    return (publicUrlObj["image_url"] as! String).count == 0
                }) {
                    print("got publicUrls of all checked images.")
                    print("self.publicUrlsOfCheckedPhotos is ", self.publicUrlsOfCheckedPhotos.description)
                    newMomentDic["photos"] = self.publicUrlsOfCheckedPhotos as Any
                    
                    Network.sharedInstance.callRattitContentService(httpRequest: .postNewMomentContent(bodyDic: newMomentDic), completion: { (dataValue) in
                        print("successfully published new moment.")
                    }, errorHandler: { (error) in
                        print("publishing new Moment got failure: \(error.localizedDescription)")
                    })
                }
                
            })
        })
        
    }
    
    // utilities
    static func phAssetToUIImage(asset: PHAsset, dimension: CGSize) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        
        var resultImage: UIImage = UIImage()
        manager.requestImage(for: asset, targetSize: dimension, contentMode: .aspectFill, options: option) { (result, info) in
            if result != nil {
                resultImage = result!
            } else {
                resultImage = UIImage(named: "owlAvatar")!
            }
        }
        return resultImage
    }
    
    static func uploadOneImageToServer(rawImage: UIImage, gotImageUrl: @escaping (String) -> Void) {
        if let photoCGImage = rawImage.cgImage {
            let photoWidth = photoCGImage.width, photoHeight = photoCGImage.height
            
            print("photoCGImage.width is ", photoWidth, "photoCGImage.height is ", photoHeight)
            let cropRect = (photoWidth < photoHeight) ?
                CGRect(x: 0, y: Int(0.5*Double(photoHeight-photoWidth)), width: photoWidth, height: photoWidth) :
                CGRect(x: Int(0.5*Double(photoWidth-photoHeight)), y: 0, width: photoHeight, height: photoHeight)
            
            if let croppedCGImage = photoCGImage.cropping(to: cropRect) {
                let croppedUIImage = UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: rawImage.imageOrientation)
                print("croppedUIImage.size is ", croppedUIImage.size.debugDescription)
                
                GalleryManager.uploadImageToS3(imageName: "captured-\(Date().timeIntervalSinceReferenceDate)", image: croppedUIImage, gotImageUrl: { (imageUrl) in
                    print("Successfully got public URL of image.")
                    DispatchQueue.main.async {
                        gotImageUrl(imageUrl)
                    }
                }, completion: {
                    print("Successfully called the GalleryManager.uploadImageToS3 func.")
                }, errorHandler: { (error) in
                    print("failed to execute GalleryManager.uploadImageToS3 func.")
                })
                
            }
        }
    }
    
}
