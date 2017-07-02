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
    var composeContentDelegate: ComposeContentDelegate? = nil
    
    var pickedPlaceFromGoogle: GoogleLocation? = nil
    
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
        self.composeContentDelegate?.updatePhotoCollectionCells()
    }
    
    func insertNewPhotoToCollection(newImage: UIImage) {
        self.imageOfPhotosOnDevice.insert(newImage, at: 0)
        self.indexOfCheckedPhotos = self.indexOfCheckedPhotos.map { (val) -> Int in
            return (val+1)
        }
        self.indexOfCheckedPhotos.append(0)
        self.composeContentDelegate?.updatePhotoCollectionCells()
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
    
    func uploadSelectedImagesToServer() {
        self.indexOfCheckedPhotos.forEach { (indexVal) in
            let selectedImage = self.imageOfPhotosOnDevice[indexVal]
            ComposeContentManager.uploadOneImageToServer(rawImage: selectedImage)
        }
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
    
    static func uploadOneImageToServer(rawImage: UIImage) {
        if let photoCGImage = rawImage.cgImage {
            let photoWidth = photoCGImage.width, photoHeight = photoCGImage.height
            
            print("photoCGImage.width is ", photoWidth, "photoCGImage.height is ", photoHeight)
            let cropRect = (photoWidth < photoHeight) ?
                CGRect(x: 0, y: Int(0.5*Double(photoHeight-photoWidth)), width: photoWidth, height: photoWidth) :
                CGRect(x: Int(0.5*Double(photoWidth-photoHeight)), y: 0, width: photoHeight, height: photoHeight)
            
            if let croppedCGImage = photoCGImage.cropping(to: cropRect) {
                let croppedUIImage = UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: rawImage.imageOrientation)
                print("croppedUIImage.size is ", croppedUIImage.size.debugDescription)
                
                GalleryManager.uploadImageToS3(imageName: "captured-\(Date().timeIntervalSinceReferenceDate)", image: croppedUIImage, completion: {
                    print("Successfully called the GalleryManager.uploadImageToS3 func.")
                }, errorHandler: { (error) in
                    print("failed to execute GalleryManager.uploadImageToS3 func.")
                })
                
            }
        }
    }
    
}
