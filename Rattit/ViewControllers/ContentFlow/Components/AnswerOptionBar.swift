//
//  AnswerOptionBar.swift
//  Rattit
//
//  Created by DINGKaile on 7/23/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class AnswerOptionBar: UIView {
    
    @IBOutlet weak var agreeImage: UIImageView!
    @IBOutlet weak var agreeTextLabel: UILabel!
    var voteToAnswer: RattitAnswerVoteType? = nil
    
    @IBOutlet weak var commentsImage: UIImageView!
    @IBOutlet weak var commentsTextLabel: UILabel!
    
    @IBOutlet weak var bookmarkImage: UIImageView!
    var bookmarked: Bool = false
    
    let reusableAgreeImage: UIImage! = UIImage(named: "up")?.withRenderingMode(.alwaysTemplate)
    let reusableDisagreeImage: UIImage! = UIImage(named: "down")?.withRenderingMode(.alwaysTemplate)
    let reusableAdmireImage: UIImage! = UIImage(named: "upOrDown")?.withRenderingMode(.alwaysTemplate)
    let reusableCommentImage: UIImage! = UIImage(named: "comments")?.withRenderingMode(.alwaysTemplate)
    let reusableBookmarkImage: UIImage! = UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate)
    let reusableBookmarkedImage: UIImage! = UIImage(named: "bookmarked")?.withRenderingMode(.alwaysTemplate)
    
    var answerId: String? = nil
    
    
    static func instantiateFromXib() -> AnswerOptionBar {
        let answerOptionBar = Bundle.main.loadNibNamed("AnswerOptionBar", owner: self, options: nil)?.first as! AnswerOptionBar
        
        return answerOptionBar
    }
    
    func initializeData(answer: Answer) {
        self.answerId = answer.id
        
    }
    
    
    @IBAction func agreeButtonPressed(_ sender: UIButton) {
        print("== like button pressed.")
        
        UIView.animate(withDuration: 0.1, animations: {
            self.agreeImage.frame = CGRect(x: 12.0, y: 12.0, width: 0.0, height: 0.0)
        }, completion: { (success) in
            self.agreeImage.frame = CGRect(x: 12.0, y: 12.0, width: 0.0, height: 0.0)
            self.agreeImage.image = self.reusableAgreeImage
            self.agreeImage.tintColor = RattitStyleColors.marrsGreen
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2.0, options: [.curveEaseIn], animations: {
                self.agreeImage.frame = CGRect(x: 2.0, y: 2.0, width: 20.0, height: 20.0)
            }, completion: nil)
        })
        
        self.voteToAnswer = RattitAnswerVoteType.typeAdmire
    }
    
    
    @IBAction func commentButtonPressed(_ sender: UIButton) {
        print("== comment button pressed.")
    }
    
    
    @IBAction func bookmarkButtonPressed(_ sender: UIButton) {
        print("bookmarkButtonPressed.")
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
