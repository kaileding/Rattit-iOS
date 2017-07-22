//
//  ReusableImageModalViewController.swift
//  Rattit
//
//  Created by DINGKaile on 7/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ReusableImageModalViewController: UIViewController {
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var pageControlIndicator: UIPageControl!
    
    
    
    @IBOutlet weak var canvasViewWidthConstraint: NSLayoutConstraint!
    
    var screenWidth: CGFloat = 0.0
    var screenHeight: CGFloat = 0.0
    var photos: [Photo] = []
    var singleScrollViews: [UIScrollView] = []
    var photoImages: [UIImageView] = []
    var startIndex: Int = 0
    var currentIndex: Int = 0
    
    var currentSingleScrollView: UIScrollView? = nil
    var currentImageView: UIImageView? = nil
    var startScaleImageViewSize: CGSize? = nil
    var startScaleFingerPosInScrollView: CGPoint? = nil
    var startScaleFingerPosInImageView: CGPoint? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.pageControlIndicator.hidesForSinglePage = true
        self.imageScrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initializeData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.scrollToStartImage()
//        print("viewDidAppear() func called.")
//        print("self.photos.count is ", self.photos.count, ", self.view.frame is ", self.view.frame.debugDescription)
//        print("self.imageScrollView.contentSize is ", self.imageScrollView.contentSize)
//        print("self.canvasView.frame is ", self.canvasView.frame.debugDescription)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pinchGestureRecognized(_ sender: UIPinchGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.began
            && sender.numberOfTouches == 2 {
            
            if self.currentIndex < self.photoImages.count
                && self.currentIndex < self.singleScrollViews.count
                && self.photoImages.count == self.singleScrollViews.count {
                
                let imageView = self.photoImages[self.currentIndex]
                let scrollView = self.singleScrollViews[self.currentIndex]
                self.currentImageView = imageView
                self.currentSingleScrollView = scrollView
                
                self.startScaleImageViewSize = imageView.frame.size
                self.startScaleFingerPosInImageView = sender.location(in: imageView)
                self.startScaleFingerPosInScrollView = sender.location(in: scrollView)
                
                print("self.startScaleFingerPosInImageView is ", self.startScaleFingerPosInImageView!.debugDescription, ", self.startScaleFingerPosInScrollView is ", self.startScaleFingerPosInScrollView!.debugDescription)
            }
        } else if sender.state == UIGestureRecognizerState.changed
            && sender.numberOfTouches == 2
            && self.currentImageView != nil
            && self.currentSingleScrollView != nil
            && self.startScaleImageViewSize != nil
            && self.startScaleFingerPosInImageView != nil
            && self.startScaleFingerPosInScrollView != nil {
            
            let newOriginX = self.startScaleFingerPosInScrollView!.x - (sender.scale)*(self.startScaleFingerPosInImageView!.x)
            let newOriginY = self.startScaleFingerPosInScrollView!.y - (sender.scale)*(self.startScaleFingerPosInImageView!.y)
            let newWidht = sender.scale * self.startScaleImageViewSize!.width
            let newHeight = sender.scale * self.startScaleImageViewSize!.height
            
            self.currentImageView!.frame = CGRect(x: newOriginX, y: newOriginY, width: newWidht, height: newHeight)
        } else if sender.state == UIGestureRecognizerState.ended
            && self.currentImageView != nil
            && self.currentSingleScrollView != nil  {
            
            if self.currentImageView!.frame.width < self.screenWidth {
                UIView.animate(withDuration: 0.2, animations: {
                    self.currentImageView!.frame = CGRect(x: 0.0, y: 0.0, width: self.screenWidth, height: self.screenHeight)
                    self.currentSingleScrollView!.contentSize = CGSize(width: self.screenWidth, height: self.screenHeight)
                })
            } else {
                self.currentSingleScrollView!.contentSize = self.currentImageView!.frame.size
                let scrollOffset = self.currentSingleScrollView!.contentOffset
                let finalOrigin = self.currentImageView!.frame.origin
                let rectToShow = CGRect(x: scrollOffset.x-finalOrigin.x, y: scrollOffset.y-finalOrigin.y, width: self.screenWidth, height: self.screenHeight)
                self.currentImageView!.frame = CGRect(origin: CGPoint.zero, size: self.currentSingleScrollView!.contentSize)
                self.currentSingleScrollView!.scrollRectToVisible(rectToShow, animated: false)
            }
            
            self.currentImageView = nil
            self.currentSingleScrollView = nil
            self.startScaleFingerPosInImageView = nil
            self.startScaleFingerPosInScrollView = nil
        }
        
    }
    
    @IBAction func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension ReusableImageModalViewController {
    
    func initializeData() {
        
        self.pageControlIndicator.numberOfPages = photos.count
        self.canvasViewWidthConstraint.constant = CGFloat(self.photos.count)*self.screenWidth
        self.canvasView.subviews.forEach({ (subview) in
            subview.removeFromSuperview()
        })
        
        if self.photos.count > 0 {
            photos.enumerated().forEach({ (index, photo) in
                let singleImageScrollView = UIScrollView(frame: CGRect(x: CGFloat(index)*self.screenWidth, y: 0.0, width: self.screenWidth, height: self.screenHeight))
                singleImageScrollView.backgroundColor = UIColor.clear
                singleImageScrollView.clipsToBounds = true
                singleImageScrollView.bounces = false
                singleImageScrollView.showsVerticalScrollIndicator = false
                singleImageScrollView.showsHorizontalScrollIndicator = false
                let photoImageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: self.screenWidth, height: self.screenHeight))
                photoImageView.backgroundColor = UIColor.clear
                photoImageView.contentMode = .scaleAspectFit
                photoImageView.clipsToBounds = true
                singleImageScrollView.addSubview(photoImageView)
                self.canvasView.addSubview(singleImageScrollView)
                
                self.singleScrollViews.append(singleImageScrollView)
                self.photoImages.append(photoImageView)
                
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
    
    func scrollToStartImage() {
        let startRectToShow = CGRect(x: CGFloat(self.startIndex)*self.screenWidth, y: 0.0, width: self.screenWidth, height: self.screenHeight)
        print("startRectToShow is ", startRectToShow.debugDescription)
        self.imageScrollView.scrollRectToVisible(startRectToShow, animated: false)
        self.currentIndex = self.startIndex
    }
}

extension ReusableImageModalViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetVal = scrollView.contentOffset.x
        let multiple = (offsetVal / self.screenWidth)
        let floorVal = floor(multiple)
        self.currentIndex = Int(floorVal)
        
        if (multiple - floorVal) < 0.2 {
            self.pageControlIndicator.currentPage = Int(floorVal)
        } else if (multiple - floorVal) > 0.8 {
            self.pageControlIndicator.currentPage = Int(floorVal+1)
        }
    }
    
}
