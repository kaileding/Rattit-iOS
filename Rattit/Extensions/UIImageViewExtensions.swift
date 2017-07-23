//
//  UIImageViewExtensions.swift
//  Rattit
//
//  Created by DINGKaile on 7/22/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func smallerThanRect(rectSize: CGSize) -> Bool {
        if self.frame.width < rectSize.width && self.frame.height < rectSize.height {
            return true
        } else {
            return false
        }
    }
    
    func fitIntoRect(rectSize: CGSize) {
        if let image = self.image {
            let aspectRatio = image.size.height / image.size.width
            if rectSize.width*aspectRatio < rectSize.height {
                let targetHeight = rectSize.width * aspectRatio
                self.frame = CGRect(x: 0.0, y: 0.5*(rectSize.height-targetHeight), width: rectSize.width, height: targetHeight)
            } else {
                let targetWidth = rectSize.height / aspectRatio
                self.frame = CGRect(x: 0.5*(rectSize.width-targetWidth), y: 0.0, width: targetWidth, height: rectSize.height)
            }
        }
    }
    
    func getCoverSize(minSize: CGSize) -> CGSize {
        let imageViewSize = self.frame.size
        if self.smallerThanRect(rectSize: minSize) {
            return minSize
        } else if imageViewSize.width < minSize.width {
            return CGSize(width: minSize.width, height: imageViewSize.height)
        } else if imageViewSize.height < minSize.height {
            return CGSize(width: imageViewSize.width, height: minSize.height)
        } else {
            return imageViewSize
        }
    }
    
    func moveIntoContentOfScrollView(minSize: CGSize) {
        let imageViewSize = self.frame.size
        if self.smallerThanRect(rectSize: minSize) {
            self.fitIntoRect(rectSize: minSize)
        } else if imageViewSize.width < minSize.width {
            self.frame = CGRect(x: 0.5*(minSize.width-imageViewSize.width), y: 0.0, width: imageViewSize.width, height: imageViewSize.height)
        } else if imageViewSize.height < minSize.height {
            self.frame = CGRect(x: 0.0, y: 0.5*(minSize.height-imageViewSize.height), width: imageViewSize.width, height: imageViewSize.height)
        } else {
            self.frame = CGRect(origin: CGPoint.zero, size: imageViewSize)
        }
    }
}
