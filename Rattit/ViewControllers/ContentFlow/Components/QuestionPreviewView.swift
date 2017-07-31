//
//  QuestionPreviewView.swift
//  Rattit
//
//  Created by DINGKaile on 7/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class QuestionPreviewView: UIView {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var contentPreviewLabel: UILabel!
    
    var questionContentLabelTopConstraint: NSLayoutConstraint? = nil
    
    
    static func instantiateFromXib() -> QuestionPreviewView {
        let questionPreviewView = Bundle.main.loadNibNamed("QuestionPreviewView", owner: self, options: nil)?.first as! QuestionPreviewView
        
        questionPreviewView.contentPreviewLabel.numberOfLines = 4
        questionPreviewView.contentPreviewLabel.text = " "
        questionPreviewView.backgroundImageView.clipsToBounds = true
        questionPreviewView.backgroundImageView.contentMode = .scaleAspectFill
        
        return questionPreviewView
    }
    
    func initializeData(title: String, words: String, photo: Photo?) {
        self.questionTitleLabel.text = title
        self.contentPreviewLabel.text = words
        
        if photo != nil {
            self.showPreviewImage()
            GalleryManager.getImageFromUrl(imageUrl: photo!.imageUrl, completion: { (image) in
                
                self.backgroundImageView.image = image
                let imageViewLayer = self.backgroundImageView.layer
                let layerMask = CAGradientLayer()
                layerMask.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
                layerMask.startPoint = CGPoint(x: 0.5, y: 0.5)
                layerMask.endPoint = CGPoint(x: 0.5, y: 1.0)
                layerMask.frame = imageViewLayer.bounds
                imageViewLayer.mask = layerMask
                self.sizeToFit()
            }, errorHandler: { (error) in
                print("Unable to get Image for the question.")
                self.hidePreviewImage()
                self.sizeToFit()
            })
        } else {
            self.hidePreviewImage()
            self.sizeToFit()
        }
    }
    
}

extension QuestionPreviewView {
    
    func showPreviewImage() {
        self.backgroundImageView.isHidden = false
        self.questionContentLabelTopConstraint?.isActive = false
        self.questionContentLabelTopConstraint = NSLayoutConstraint(item: self.contentPreviewLabel, attribute: .top, relatedBy: .equal, toItem: self.backgroundImageView, attribute: .bottom, multiplier: 1.0, constant: -10.0)
        self.questionContentLabelTopConstraint!.isActive = true
    }
    
    func hidePreviewImage() {
        self.backgroundImageView.isHidden = true
        self.questionContentLabelTopConstraint?.isActive = false
        self.questionContentLabelTopConstraint = self.contentPreviewLabel.topAnchor.constraint(equalTo: self.questionTitleLabel.bottomAnchor, constant: 8.0)
        self.questionContentLabelTopConstraint!.isActive = true
    }
}

