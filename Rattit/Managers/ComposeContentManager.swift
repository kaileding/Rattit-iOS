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
    
}
