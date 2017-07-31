//
//  AnswerTableViewCell.swift
//  Rattit
//
//  Created by DINGKaile on 7/20/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {
    
    var answerHeaderView: MainContentHeaderView! = MainContentHeaderView.instantiateFromXib()
    
    var answerPreviewView: AnswerPreviewView! = AnswerPreviewView.instantiateFromXib()
    
    var answerOptionBar: AnswerOptionBar! = AnswerOptionBar.instantiateFromXib()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let margins = self.contentView.layoutMarginsGuide
        // setup questionHeaderView
        self.answerHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.answerHeaderView.removeFromSuperview()
        self.contentView.addSubview(self.answerHeaderView)
        self.answerHeaderView?.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        self.answerHeaderView?.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        self.answerHeaderView?.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        
        // setup questionPreviewView
        self.answerPreviewView.translatesAutoresizingMaskIntoConstraints = false
        self.answerPreviewView.removeFromSuperview()
        self.contentView.addSubview(self.answerPreviewView)
        
        self.answerPreviewView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8.0).isActive = true
        self.answerPreviewView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 8.0).isActive = true
        self.answerPreviewView.topAnchor.constraint(equalTo: self.answerHeaderView.bottomAnchor).isActive = true
        
        // setup questionOptionBar
        self.answerOptionBar.translatesAutoresizingMaskIntoConstraints = false
        self.answerOptionBar.removeFromSuperview()
        self.contentView.addSubview(self.answerOptionBar)
        self.answerOptionBar.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: -8.0).isActive = true
        self.answerOptionBar.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 8.0).isActive = true
        self.answerOptionBar.topAnchor.constraint(equalTo: self.answerPreviewView.bottomAnchor, constant: 0.0).isActive = true
        self.answerOptionBar.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0.0).isActive = true
        let answerOptionBarHeightConstraint = self.answerOptionBar.heightAnchor.constraint(equalToConstant: 38.0)
        answerOptionBarHeightConstraint.priority = 999
        answerOptionBarHeightConstraint.isActive = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initializeContent(answer: Answer, sideLength: Double, flowDelegate: ContentFlowDelegate) {
        
        self.answerHeaderView.initializeData(mainContent: answer as MainContent, actionStr: "answered", flowDelegate: flowDelegate)
        let answerPhoto = answer.photos?.first
        self.answerPreviewView.initializeData(title: answer.questionTitle, words: answer.words, photo: answerPhoto)
        self.answerOptionBar.initializeData(answer: answer)
        
        self.answerPreviewView.sizeToFit()
    }
    
}
