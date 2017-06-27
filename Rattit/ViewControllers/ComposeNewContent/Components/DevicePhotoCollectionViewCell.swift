//
//  DevicePhotoCollectionViewCell.swift
//  Rattit
//
//  Created by DINGKaile on 6/25/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit
import Photos

class DevicePhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var photoSurfaceButton: UIButton!
    
    
    var checkedWithIndex: Int = 0
    var indexOfPhotosInDevice: Int = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.canvasView.translatesAutoresizingMaskIntoConstraints = false
        self.photoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.checkMarkImageView.translatesAutoresizingMaskIntoConstraints = false
        self.photoSurfaceButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.photoSurfaceButton.addTarget(self, action: #selector(photoSurfaceButtonPressed), for: .touchUpInside)
    }
    
    func initializeData(assetIndex: Int) {
        
        let outWidth = self.frame.width
        let imageSize = CGSize(width: (outWidth-4.0), height: (outWidth-4.0))
        
        self.indexOfPhotosInDevice = assetIndex
        let asset = ComposeContentManager.photoAssetsOnDivece!.object(at: assetIndex)
        let image = self.phAssetToUIImage(asset: asset, dimension: imageSize)
        self.photoImageView.image = image
        self.photoImageView.contentMode = .scaleAspectFill
        self.photoImageView.clipsToBounds = true
        
        self.checkedWithIndex = ComposeContentManager.photosOnDeviceCheckArray![assetIndex]
        self.checkMarkImageView.image = UIImage(named: "checkMark")?.withRenderingMode(.alwaysTemplate)
        if self.checkedWithIndex == 0 {
            self.checkMarkImageView.tintColor = UIColor.white
        } else {
            self.checkMarkImageView.tintColor = UIColor(red: 0, green: 0.5569, blue: 0.2039, alpha: 1.0)
        }
        
        self.checkMarkImageView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.checkMarkImageView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.checkMarkImageView.bottomAnchor.constraint(equalTo: self.canvasView.bottomAnchor, constant: -2.0).isActive = true
        self.checkMarkImageView.trailingAnchor.constraint(equalTo: self.canvasView.trailingAnchor, constant: -2.0).isActive = true
        self.layoutIfNeeded()
    }
    
    func phAssetToUIImage(asset: PHAsset, dimension: CGSize) -> UIImage {
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
    
    func photoSurfaceButtonPressed() {
        if self.checkedWithIndex == 0 {
            self.checkMarkImageView.tintColor = UIColor(red: 0, green: 0.5569, blue: 0.2039, alpha: 1.0)
            ComposeContentManager.numberOfPhotosChecked += 1
            self.checkedWithIndex = ComposeContentManager.numberOfPhotosChecked
            ComposeContentManager.photosOnDeviceCheckArray![self.indexOfPhotosInDevice] = self.checkedWithIndex
            print("photoSurfaceButtonPressed func. now have \(ComposeContentManager.numberOfPhotosChecked) checked.")
        } else {
            self.checkMarkImageView.tintColor = UIColor.white
            ComposeContentManager.numberOfPhotosChecked -= 1
            self.checkedWithIndex = 0
            ComposeContentManager.photosOnDeviceCheckArray![self.indexOfPhotosInDevice] = self.checkedWithIndex
            print("photoSurfaceButtonPressed func. now have \(ComposeContentManager.numberOfPhotosChecked) checked.")
        }
    }
}
