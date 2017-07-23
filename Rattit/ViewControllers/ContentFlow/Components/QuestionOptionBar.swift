//
//  QuestionOptionBar.swift
//  Rattit
//
//  Created by DINGKaile on 7/22/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class QuestionOptionBar: UIView {
    
    
    
    @IBOutlet weak var bookmarkImage: UIImageView!
    
    
    var questionId: String? = nil
    
    
    
    static func instantiateFromXib() -> QuestionOptionBar {
        let questionOptionBar = Bundle.main.loadNibNamed("QuestionOptionBar", owner: self, options: nil)?.first as! QuestionOptionBar
        
        return questionOptionBar
    }
    
    func initializeData(question: Question) {
        self.questionId = question.id
        
        
    }
    
    
    
    @IBAction func bookmarkImagePressed(_ sender: UIButton) {
        print("bookmarkImagePressed.")
    }
    
}
