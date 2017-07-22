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
    
    
    static func instantiateFromXib() -> ContentTitleWordsView {
        let contentTitleWordsView = Bundle.main.loadNibNamed("ContentTitleWordsView", owner: self, options: nil)?.first as! ContentTitleWordsView
        
        contentTitleWordsView.wordsLabel.numberOfLines = 4
        
        return contentTitleWordsView
    }
    
    func initializeData(title: String, words: String) {
        self.titleLabel.text = title
        self.wordsLabel.text = words
        self.sizeToFit()
    }
    
}
