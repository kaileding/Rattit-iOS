//
//  QuestionTableViewCell.swift
//  Rattit
//
//  Created by DINGKaile on 7/20/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    var questionHeaderView: MainContentHeaderView! = MainContentHeaderView.instantiateFromXib()
    
    var questionPreviewView: QuestionPreviewView! = QuestionPreviewView.instantiateFromXib()
    
    var questionOptionBar: QuestionOptionBar! = QuestionOptionBar.instantiateFromXib()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = RattitStyleColors.backgroundGray
        
        let margins = self.contentView.layoutMarginsGuide
        // setup questionHeaderView
        self.questionHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.questionHeaderView.removeFromSuperview()
        self.contentView.addSubview(self.questionHeaderView)
        self.questionHeaderView?.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.questionHeaderView?.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.questionHeaderView?.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        
        // setup questionPreviewView
        self.questionPreviewView.translatesAutoresizingMaskIntoConstraints = false
        self.questionPreviewView.removeFromSuperview()
        self.contentView.addSubview(self.questionPreviewView)
        
        self.questionPreviewView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8.0).isActive = true
        self.questionPreviewView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 8.0).isActive = true
        self.questionPreviewView.topAnchor.constraint(equalTo: self.questionHeaderView.bottomAnchor).isActive = true
        
        // setup questionOptionBar
        self.questionOptionBar.translatesAutoresizingMaskIntoConstraints = false
        self.questionOptionBar.removeFromSuperview()
        self.contentView.addSubview(self.questionOptionBar)
        self.questionOptionBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8.0).isActive = true
        self.questionOptionBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 8.0).isActive = true
        self.questionOptionBar.topAnchor.constraint(equalTo: self.questionPreviewView.bottomAnchor, constant: 0.0).isActive = true
        self.questionOptionBar.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8.0).isActive = true
        let questionOptionBarHeightConstraint = self.questionOptionBar.heightAnchor.constraint(equalToConstant: 38.0)
        questionOptionBarHeightConstraint.priority = 999
        questionOptionBarHeightConstraint.isActive = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeContent(question: Question, sideLength: Double, flowDelegate: ContentFlowDelegate) {
        
        self.questionHeaderView.initializeData(mainContent: question as MainContent, actionStr: "asked", flowDelegate: flowDelegate)
//        let questionPhoto = question.photos?.first
        self.questionPreviewView.initializeData(question: question, flowDelegate: flowDelegate)
//        a(questionId: question.id!, flowDelegate: flowDelegate)
//        ta(title: question.title, words: question.words, photo: questionPhoto)
        self.questionOptionBar.initializeData(question: question)
        
        self.questionPreviewView.sizeToFit()
    }
    
}
