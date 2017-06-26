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
    
    var canvasWidthConstraint: NSLayoutConstraint? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.canvasView.translatesAutoresizingMaskIntoConstraints = false
        self.photoImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func initializeData(asset: PHAsset) {
        
        let outWidth = self.frame.width
        let imageSize = CGSize(width: (outWidth-4.0), height: (outWidth-4.0))
        
        let image = self.phAssetToUIImage(asset: asset, dimension: imageSize)
        self.photoImageView.image = image
        self.photoImageView.contentMode = .scaleAspectFill
        self.photoImageView.clipsToBounds = true
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

}
