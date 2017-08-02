//
//  AnswerDetailsVCNavTitleBarView.swift
//  Rattit
//
//  Created by DINGKaile on 8/2/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class AnswerDetailsVCNavTitleBarView: UIView {
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var numOfAnswersLabel: UILabel!
    
    @IBOutlet weak var titleBarButton: UIButton!
    
    var questionId: String? = nil
    var navBarButtonHandler: ((String) -> Void)? = nil
    
    static func instantiateFromXib() -> AnswerDetailsVCNavTitleBarView {
        let navTitleBarView = Bundle.main.loadNibNamed("AnswerDetailsVCNavTitleBarView", owner: self, options: nil)?.first as! AnswerDetailsVCNavTitleBarView
        
//        navTitleBarView.translatesAutoresizingMaskIntoConstraints = false
        navTitleBarView.titleBarButton.addTarget(navTitleBarView, action: #selector(navBarButtonPressed), for: .touchUpInside)
        
        return navTitleBarView
    }
    
    func initializeData(questionId: String) {
        
        self.questionId = questionId
        
        if let question = QuestionManager.sharedInstance.downloadedContents[questionId] {
            self.questionTitleLabel.text = question.title
            self.numOfAnswersLabel.text = "- answers"
        }
    }
    
    func navBarButtonPressed() {
        if self.navBarButtonHandler != nil && self.questionId != nil {
            self.navBarButtonHandler!(self.questionId!)
        }
    }
}
