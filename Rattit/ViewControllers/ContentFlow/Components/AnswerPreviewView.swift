//
//  AnswerPreviewView.swift
//  Rattit
//
//  Created by DINGKaile on 7/23/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class AnswerPreviewView: UIView {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var answerContentLabel: UILabel!
    
    var answerContentLabelTopConstraint: NSLayoutConstraint? = nil
    
    
    static func instantiateFromXib() -> AnswerPreviewView {
        let answerPreviewView = Bundle.main.loadNibNamed("AnswerPreviewView", owner: self, options: nil)?.first as! AnswerPreviewView
        
        answerPreviewView.answerContentLabel.numberOfLines = 4
        answerPreviewView.answerContentLabel.text = " "
        answerPreviewView.backgroundImageView.clipsToBounds = true
        answerPreviewView.backgroundImageView.contentMode = .scaleAspectFill
        
        return answerPreviewView
    }
    
    func initializeData(title: String?, words: String, photo: Photo?) {
        self.questionTitleLabel.text = title
        self.answerContentLabel.text = words
        
        if photo != nil {
            self.showPreviewImage()
            GalleryManager.getImageFromUrl(imageUrl: photo!.imageUrl, completion: { (image) in
                
                self.backgroundImageView.image = image
//                let imageViewLayer = self.backgroundImageView.layer
//                let layerMask = CAGradientLayer()
//                layerMask.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
//                layerMask.startPoint = CGPoint(x: 0.5, y: 0.5)
//                layerMask.endPoint = CGPoint(x: 0.5, y: 1.0)
//                layerMask.frame = imageViewLayer.bounds
//                imageViewLayer.mask = layerMask
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

extension AnswerPreviewView {
    
    func showPreviewImage() {
        self.backgroundImageView.isHidden = false
        self.answerContentLabelTopConstraint?.isActive = false
        self.answerContentLabelTopConstraint = NSLayoutConstraint(item: self.answerContentLabel, attribute: .top, relatedBy: .equal, toItem: self.backgroundImageView, attribute: .bottom, multiplier: 1.0, constant: 4.0)
        self.answerContentLabelTopConstraint!.isActive = true
    }
    
    func hidePreviewImage() {
        self.backgroundImageView.isHidden = true
        self.answerContentLabelTopConstraint?.isActive = false
        self.answerContentLabelTopConstraint = self.answerContentLabel.topAnchor.constraint(equalTo: self.questionTitleLabel.bottomAnchor, constant: 8.0)
        self.answerContentLabelTopConstraint!.isActive = true
    }
}
