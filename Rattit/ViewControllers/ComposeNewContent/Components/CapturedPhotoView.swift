//
//  CapturedPhotoView.swift
//  Rattit
//
//  Created by DINGKaile on 6/25/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class CapturedPhotoView: UIView {
    
    @IBOutlet weak var capturedPhotoImageView: UIImageView!
    
    @IBOutlet weak var imageSurfaceButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var cancelButtonLeadingConstraint: NSLayoutConstraint? = nil
    var confirmButtonLeadingConstraint: NSLayoutConstraint? = nil
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static func instantiateFromXib() -> CapturedPhotoView {
        let capturedPhotoView = Bundle.main.loadNibNamed("CapturedPhotoView", owner: self, options: nil)?.first as! CapturedPhotoView
        
        capturedPhotoView.translatesAutoresizingMaskIntoConstraints = false
        capturedPhotoView.imageSurfaceButton.translatesAutoresizingMaskIntoConstraints = false
        capturedPhotoView.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        capturedPhotoView.confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        capturedPhotoView.capturedPhotoImageView.clipsToBounds = true
        capturedPhotoView.capturedPhotoImageView.contentMode = .scaleAspectFill
        
        capturedPhotoView.imageSurfaceButton.addTarget(capturedPhotoView, action: #selector(imageSurfaceButtonPressed), for: .touchUpInside)
        capturedPhotoView.cancelButton.addTarget(capturedPhotoView, action: #selector(cancelButtonPressed), for: .touchUpInside)
        capturedPhotoView.confirmButton.addTarget(capturedPhotoView, action: #selector(confirmButtonPressed), for: .touchUpInside)
        
        capturedPhotoView.cancelButton.setImage(UIImage(named: "crossMark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        capturedPhotoView.cancelButton.tintColor = UIColor.white
        capturedPhotoView.confirmButton.setImage(UIImage(named: "checkMark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        capturedPhotoView.confirmButton.tintColor = UIColor.white
        
        return capturedPhotoView
    }
    
    func initializeContent(image: UIImage) {
        self.capturedPhotoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        self.capturedPhotoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        self.capturedPhotoImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        self.capturedPhotoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        
        self.capturedPhotoImageView.image = image
        self.capturedPhotoImageView.clipsToBounds = true
        self.capturedPhotoImageView.contentMode = .scaleAspectFill
        
        let totalWidth = self.frame.width
        self.imageSurfaceButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        self.imageSurfaceButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        self.imageSurfaceButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        self.imageSurfaceButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        self.layoutIfNeeded()
        
        self.cancelButton.frame = CGRect(x: -35.0, y: (totalWidth-50.0), width: 30.0, height: 30.0)
        self.confirmButton.frame = CGRect(x: -35.0, y: (totalWidth-50.0), width: 30.0, height: 30.0)
//        print("\nin initializeContent() func, the self.frame is ", self.frame.debugDescription, ". totalWidth is ", totalWidth, ". capturedPhotoImageView.frame is ", self.capturedPhotoImageView.frame.debugDescription, ". imageSurfaceButton.frame is ", self.imageSurfaceButton.frame.debugDescription)
        
        self.animateButtonsFromLeftToRight()
    }
    
    func imageSurfaceButtonPressed() {
        print("imageSurfaceButtonPressed func.")
        
        if (self.cancelButton.center.x < 0) {
            self.animateButtonsFromLeftToRight()
        } else {
            self.animateButtonsDropDown()
        }
        
//        let animator = UIDynamicAnimator(referenceView: self)
//        animator.addBehavior(UIGravityBehavior(items: [self.cancelButton, self.confirmButton]))
        
    }
    
    func animateButtonsFromLeftToRight() {
        let totalWidth = self.frame.width
        let cancelButtonLeadingSpace = 0.5*totalWidth - 45.0
        let confirmButtonLeadingSpace = 0.5*totalWidth + 15.0
//        print("\nin animateButtonsFromLeftToRight() func, the self.frame is ", self.frame.debugDescription, ". totalWidth is ", totalWidth, ". capturedPhotoImageView.frame is ", self.capturedPhotoImageView.frame.debugDescription, ". imageSurfaceButton.frame is ", self.imageSurfaceButton.frame.debugDescription, ". cancelButton.frame is ", self.cancelButton.frame.debugDescription)
        
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2.0, options: [.curveEaseIn], animations: {
            
            self.cancelButton.frame = CGRect(x: cancelButtonLeadingSpace, y: (totalWidth-50.0), width: 30.0, height: 30.0)
            self.confirmButton.frame = CGRect(x: confirmButtonLeadingSpace, y: (totalWidth-50.0), width: 30.0, height: 30.0)
            
        }, completion: {(success) in
//            print("animation finish: cancelButton.frame is ", self.cancelButton.frame.debugDescription)
//            print("animation finish: confirmButton.frame is ", self.confirmButton.frame.debugDescription)
//            print("animation finish: imageSurfaceButton.frame is ", self.imageSurfaceButton.frame.debugDescription)
        })
    }
    
    func animateButtonsDropDown() {
        let totalWidth = self.frame.width
        let cancelButtonLeadingSpace = 0.5*totalWidth - 45.0
        let confirmButtonLeadingSpace = 0.5*totalWidth + 15.0
//        print("\nin animateButtonsDropDown() func, the self.frame is ", self.frame.debugDescription, ". totalWidth is ", totalWidth, ". capturedPhotoImageView.frame is ", self.capturedPhotoImageView.frame.debugDescription, ". imageSurfaceButton.frame is ", self.imageSurfaceButton.frame.debugDescription, ". cancelButton.frame is ", self.cancelButton.frame.debugDescription)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            self.cancelButton.frame = CGRect(x: cancelButtonLeadingSpace, y: (totalWidth+20.0), width: 30.0, height: 30.0)
        }, completion: {(success) in
            self.cancelButton.frame = CGRect(x: -35.0, y: (totalWidth-50.0), width: 30.0, height: 30.0)
        })
        UIView.animate(withDuration: 0.2, delay: 0.05, options: [], animations: {
            self.confirmButton.frame = CGRect(x: confirmButtonLeadingSpace, y: (totalWidth+20.0), width: 30.0, height: 30.0)
        }, completion: {(success) in
            self.confirmButton.frame = CGRect(x: -35.0, y: (totalWidth-50.0), width: 30.0, height: 30.0)
        })
    }
    
    
    func cancelButtonPressed() {
        print("cancelButtonPressed func.")
        self.removeFromSuperview()
    }
    
    func confirmButtonPressed() {
        print("confirmButtonPressed func. Prepare to upload image file.")
        
//        self.uploadImageToServer()
        self.saveImageToDeviceLibrary()
        self.removeFromSuperview()
    }
    
    func uploadImageToServer() {
        if let photoFile = self.capturedPhotoImageView.image, let photoCGImage = photoFile.cgImage {
            let photoWidth = photoCGImage.width, photoHeight = photoCGImage.height
            
            print("photoCGImage.width is ", photoWidth, "photoCGImage.height is ", photoHeight)
            let cropRect = (photoWidth < photoHeight) ?
                CGRect(x: 0, y: Int(0.5*Double(photoHeight-photoWidth)), width: photoWidth, height: photoWidth) :
                CGRect(x: Int(0.5*Double(photoWidth-photoHeight)), y: 0, width: photoHeight, height: photoHeight)
            
            if let croppedCGImage = photoCGImage.cropping(to: cropRect) {
                let croppedUIImage = UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: photoFile.imageOrientation)
                print("croppedUIImage.size is ", croppedUIImage.size.debugDescription)
                
                GalleryManager.uploadImageToS3(imageName: "captured-\(Date().timeIntervalSinceReferenceDate)", image: croppedUIImage, completion: {
                    print("Successfully called the GalleryManager.uploadImageToS3 func.")
                }, errorHandler: { (error) in
                    print("failed to execute GalleryManager.uploadImageToS3 func.")
                })
                
            }
        }
    }
    
    func saveImageToDeviceLibrary() {
        if let photoFile = self.capturedPhotoImageView.image {
            ComposeContentManager.sharedInstance.insertNewPhotoToCollection(newImage: photoFile)
            UIImageWriteToSavedPhotosAlbum(photoFile, self, #selector(writeToLibrary), nil)
        }
    }
    
    func writeToLibrary(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Unable to save to device library.", error.localizedDescription)
        } else {
            print("Save to device library successfully.")
        }
    }

}
