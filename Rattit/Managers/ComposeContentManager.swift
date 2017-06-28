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
    
    func updateOtherPhotoCells() {
        self.composeContentDelegate?.updatePhotoCollectionCells()
    }
    
}
