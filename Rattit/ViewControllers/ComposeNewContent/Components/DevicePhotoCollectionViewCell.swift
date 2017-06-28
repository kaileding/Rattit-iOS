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
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var photoSurfaceButton: UIButton!
    
    let checkedImage = UIImage(named: "roundDot")?.withRenderingMode(.alwaysTemplate)
    let notCheckedImage = UIImage(named: "checkMark")?.withRenderingMode(.alwaysTemplate)
    
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
        self.indexLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.photoSurfaceButton.addTarget(self, action: #selector(photoSurfaceButtonPressed), for: .touchUpInside)
    }
    
    func initializeData(assetIndex: Int) {
        
        self.indexOfPhotosInDevice = assetIndex
        self.photoImageView.image = ComposeContentManager.sharedInstance.imageOfPhotosOnDevice[assetIndex]
        self.photoImageView.contentMode = .scaleAspectFill
        self.photoImageView.clipsToBounds = true
        
        self.checkedWithIndex = ComposeContentManager.sharedInstance.getCheckIndexValue(forCell: assetIndex)
        if self.checkedWithIndex == 0 {
            self.checkMarkImageView.image = self.notCheckedImage
            self.checkMarkImageView.tintColor = UIColor.white
            self.indexLabel.isHidden = true
        } else {
            self.checkMarkImageView.image = self.checkedImage
            self.checkMarkImageView.tintColor = UIColor(red: 0, green: 0.5569, blue: 0.2039, alpha: 1.0)
            self.indexLabel.isHidden = false
            self.indexLabel.text = "\(self.checkedWithIndex)"
        }
        
        self.checkMarkImageView.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.checkMarkImageView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.checkMarkImageView.bottomAnchor.constraint(equalTo: self.canvasView.bottomAnchor, constant: -2.0).isActive = true
        self.checkMarkImageView.trailingAnchor.constraint(equalTo: self.canvasView.trailingAnchor, constant: -2.0).isActive = true
        
        self.indexLabel.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.indexLabel.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        self.indexLabel.bottomAnchor.constraint(equalTo: self.canvasView.bottomAnchor, constant: -2.0).isActive = true
        self.indexLabel.trailingAnchor.constraint(equalTo: self.canvasView.trailingAnchor, constant: -2.0).isActive = true
        
        self.layoutIfNeeded()
    }
    
    func photoSurfaceButtonPressed() {
        let width = self.frame.width
        if self.checkedWithIndex == 0 {
            ComposeContentManager.sharedInstance.checkAPhoto(atCell: self.indexOfPhotosInDevice)
            self.checkedWithIndex = ComposeContentManager.sharedInstance.getCheckIndexValue(forCell: self.indexOfPhotosInDevice)
            
            
            self.checkMarkImageView.image = self.checkedImage
            self.checkMarkImageView.tintColor = UIColor(red: 0, green: 0.5569, blue: 0.2039, alpha: 1.0)
            self.checkMarkImageView.frame = CGRect(x: (width-17.0), y: (width-17.0), width: 0.0, height: 0.0)
            self.indexLabel.text = "\(self.self.checkedWithIndex)"
            self.indexLabel.isHidden = true
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: [.curveEaseIn], animations: {
                self.checkMarkImageView.frame = CGRect(x: (width-32.0), y: (width-32.0), width: 30.0, height: 30.0)
                self.indexLabel.isHidden = false
            }, completion: { (success) in
                print("success: \(success)")
                ComposeContentManager.sharedInstance.updateAllPhotoCells()
            })
        } else {
            ComposeContentManager.sharedInstance.uncheckAPhoto(atCell: self.indexOfPhotosInDevice)
            self.checkedWithIndex = ComposeContentManager.sharedInstance.getCheckIndexValue(forCell: self.indexOfPhotosInDevice)
            
            UIView.animate(withDuration: 0.1, animations: {
                self.checkMarkImageView.frame = CGRect(x: (width-17.0), y: (width-17.0), width: 0.0, height: 0.0)
                self.indexLabel.isHidden = true
            }, completion: { (success) in
                self.checkMarkImageView.frame = CGRect(x: (width-32.0), y: (width-32.0), width: 30.0, height: 30.0)
                self.checkMarkImageView.image = self.notCheckedImage
                self.checkMarkImageView.tintColor = UIColor.white
                self.indexLabel.text = "0"
                self.indexLabel.isHidden = true
                ComposeContentManager.sharedInstance.updateAllPhotoCells()
            })
            
        }
    }
}
