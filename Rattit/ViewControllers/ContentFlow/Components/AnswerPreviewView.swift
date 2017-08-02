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
    @IBOutlet weak var answerPriviewButton: UIButton!
    
    var answerContentLabelTopConstraint: NSLayoutConstraint? = nil
    var answerId: String!
    var flowDelegate: ContentFlowDelegate? = nil
    
    
    static func instantiateFromXib() -> AnswerPreviewView {
        let answerPreviewView = Bundle.main.loadNibNamed("AnswerPreviewView", owner: self, options: nil)?.first as! AnswerPreviewView
        
        answerPreviewView.answerContentLabel.numberOfLines = 4
        answerPreviewView.answerContentLabel.text = " "
        answerPreviewView.backgroundImageView.clipsToBounds = true
        answerPreviewView.backgroundImageView.contentMode = .scaleAspectFill
        answerPreviewView.answerPriviewButton.addTarget(answerPreviewView, action: #selector(preViewButtonPressed), for: .touchUpInside)
        
        return answerPreviewView
    }
    
    func initializeData(answer: Answer, flowDelegate: ContentFlowDelegate) {
        
        self.answerId = answer.id!
        self.flowDelegate = flowDelegate
        self.questionTitleLabel.text = answer.questionTitle
        self.answerContentLabel.text = answer.words
        if let photo = answer.photos?.first {
            self.showPreviewImage()
            GalleryManager.getImageFromUrl(imageUrl: photo.imageUrl, completion: { (image) in
                
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
    
    func preViewButtonPressed() {
        if self.flowDelegate != nil {
            self.flowDelegate?.aContentCellIsSelected(contentId: self.answerId, contentType: .answer)
        }
    }
}
