//
//  PhotoScrollView.swift
//  Rattit
//
//  Created by DINGKaile on 6/22/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class PhotoScrollView: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var canvasView: UIView! = UIView()
    
    @IBOutlet weak var pageControlIndicator: UIPageControl!
    
    var savedPhotos: [Photo]? = nil
    var savedSideLength: Double? = nil
    
    var currentIndex: Int = 0
    
    static func instantiateFromXib() -> PhotoScrollView {
        let photoScrollView = Bundle.main.loadNibNamed("PhotoScrollView", owner: self, options: nil)?.first as! PhotoScrollView
        
        photoScrollView.scrollView.addSubview(photoScrollView.canvasView)
        photoScrollView.pageControlIndicator.hidesForSinglePage = true
        photoScrollView.scrollView.delegate = photoScrollView
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: photoScrollView, action: #selector(tappedImage))
        photoScrollView.addGestureRecognizer(tapGestureRecognizer)
        
        return photoScrollView
    }
    
    
    func initializeData(photos: [Photo], sideLength: Double) {
        self.savedPhotos = photos
        self.savedSideLength = sideLength
        self.pageControlIndicator.numberOfPages = photos.count
        
        if photos.count > 0 {
            self.canvasView.frame = CGRect(x: 0.0, y: 0.0, width: (sideLength*Double(photos.count)), height: 0.6*sideLength)
            self.canvasView.subviews.forEach({ (subview) in
                subview.removeFromSuperview()
            })
            self.scrollView.contentSize = self.canvasView.frame.size
            
            photos.enumerated().forEach({ (index, photo) in
                let imageFrame = CGRect(x: Double(index)*sideLength, y: 0.0, width: sideLength, height: 0.6*sideLength)
                let photoImageView = UIImageView(frame: imageFrame)
                photoImageView.contentMode = .scaleAspectFill
                photoImageView.clipsToBounds = true
                self.canvasView.addSubview(photoImageView)
                
                GalleryManager.getImageFromUrl(imageUrl: photo.imageUrl, completion: { (image) in
                    photoImageView.image = image
                }, errorHandler: { (error) in
                    print("Unable to get photo.")
                    photoImageView.image = UIImage(named: "lazyOwl")
                })
            })
            
        } else {
            print("No photo element at all.")
        }
    }
    
    func tappedImage() {
        if self.savedPhotos != nil {
            let modalContentInfo = ObjectForShowImagesModal(photos: self.savedPhotos!, startIndex: self.currentIndex)
            NotificationCenter.default.post(name: NSNotification.Name(ContentOperationNotificationName.showImagesModal.rawValue), object: modalContentInfo, userInfo: nil)
        }
    }
    
}

extension PhotoScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetVal = Double(scrollView.contentOffset.x)
        if let sideLength = self.savedSideLength {
            let multiple = (offsetVal / sideLength)
            let floorVal = floor(multiple)
            self.currentIndex = Int(floorVal)
            
            if multiple == floorVal {
                self.pageControlIndicator.isHidden = true
            } else if (multiple - floorVal) < 0.5 {
                self.pageControlIndicator.isHidden = false
                self.pageControlIndicator.currentPage = Int(floorVal)
            } else {
                self.pageControlIndicator.isHidden = false
                self.pageControlIndicator.currentPage = Int(floorVal+1)
            }
        }
    }
    
}


