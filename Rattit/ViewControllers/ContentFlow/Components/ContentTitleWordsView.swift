//
//  ContentTitleWordsView.swift
//  Rattit
//
//  Created by DINGKaile on 7/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ContentTitleWordsView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wordsLabel: UILabel!
    @IBOutlet weak var textButton: UIButton!
    
    var momentId: String!
    var flowDelegate: ContentFlowDelegate? = nil
    
    static func instantiateFromXib() -> ContentTitleWordsView {
        let contentTitleWordsView = Bundle.main.loadNibNamed("ContentTitleWordsView", owner: self, options: nil)?.first as! ContentTitleWordsView
        
        contentTitleWordsView.textButton.addTarget(contentTitleWordsView, action: #selector(textButtonPressed), for: .touchUpInside)
        contentTitleWordsView.wordsLabel.numberOfLines = 4
        
        return contentTitleWordsView
    }
    
    func initializeData(momentId: String, flowDelegate: ContentFlowDelegate) {
        self.momentId = momentId
        let moment = MomentManager.sharedInstance.downloadedContents[momentId]
        self.titleLabel.text = moment!.title
        self.wordsLabel.text = moment!.words
        self.flowDelegate = flowDelegate
        self.sizeToFit()
    }
    
    func textButtonPressed() {
        if self.flowDelegate != nil {
            self.flowDelegate?.aContentCellIsSelected(contentId: self.momentId, contentType: .moment)
        }
    }
    
}
