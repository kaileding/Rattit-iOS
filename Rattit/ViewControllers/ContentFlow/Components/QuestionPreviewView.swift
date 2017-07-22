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
    @IBOutlet weak var contentPreviewLabel: UILabel!
    
    
    
    static func instantiateFromXib() -> QuestionPreviewView {
        let questionPreviewView = Bundle.main.loadNibNamed("QuestionPreviewView", owner: self, options: nil)?.first as! QuestionPreviewView
        
        questionPreviewView.contentPreviewLabel.text = ""
        
        
        return questionPreviewView
    }
    

}
