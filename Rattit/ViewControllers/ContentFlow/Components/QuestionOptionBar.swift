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
    var bookmarked: Bool = false
    
    let reusableLikeImage: UIImage! = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
    let reusableLikedImage: UIImage! = UIImage(named: "liked")?.withRenderingMode(.alwaysTemplate)
    let reusableCommentImage: UIImage! = UIImage(named: "comments")?.withRenderingMode(.alwaysTemplate)
    let reusableBookmarkImage: UIImage! = UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate)
    let reusableBookmarkedImage: UIImage! = UIImage(named: "bookmarked")?.withRenderingMode(.alwaysTemplate)
    
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
        if self.bookmarked == false {
            UIView.animate(withDuration: 0.1, animations: {
                self.bookmarkImage.frame = CGRect(x: 12.0, y: 12.0, width: 0.0, height: 0.0)
            }, completion: { (success) in
                self.bookmarkImage.frame = CGRect(x: 12.0, y: 12.0, width: 0.0, height: 0.0)
                self.bookmarkImage.image = self.reusableBookmarkedImage
                self.bookmarkImage.tintColor = RattitStyleColors.bookmarkDarkBlue
                UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2.0, options: [.curveEaseIn], animations: {
                    self.bookmarkImage.frame = CGRect(x: 2.0, y: 2.0, width: 20.0, height: 20.0)
                }, completion: nil)
            })
            self.bookmarked = true
        } else {
            self.bookmarkImage.image = self.reusableBookmarkImage
            self.bookmarkImage.tintColor = UIColor.darkGray
            self.bookmarked = false
        }
    }
}
