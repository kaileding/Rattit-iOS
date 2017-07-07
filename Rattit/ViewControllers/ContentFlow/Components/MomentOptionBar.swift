//
//  MomentOptionBar.swift
//  Rattit
//
//  Created by DINGKaile on 6/22/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class MomentOptionBar: UIView {
    
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeTextLabel: UILabel!
    var liked: Bool = false
    
    @IBOutlet weak var commentsImage: UIImageView!
    @IBOutlet weak var commentsTextLabel: UILabel!
    
    @IBOutlet weak var bookmarkImage: UIImageView!
    var bookmarked: Bool = false
    
    let reusableLikeImage: UIImage! = UIImage(named: "like")?.withRenderingMode(.alwaysTemplate)
    let reusableLikedImage: UIImage! = UIImage(named: "liked")?.withRenderingMode(.alwaysTemplate)
    let reusableCommentImage: UIImage! = UIImage(named: "comments")?.withRenderingMode(.alwaysTemplate)
    let reusableBookmarkImage: UIImage! = UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate)
    let reusableBookmarkedImage: UIImage! = UIImage(named: "bookmarked")?.withRenderingMode(.alwaysTemplate)
    
    var momentId: String? = nil
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static func instantiateFromXib() -> MomentOptionBar {
        let momentOptionBar = Bundle.main.loadNibNamed("MomentOptionBar", owner: self, options: nil)?.first as! MomentOptionBar
        
        momentOptionBar.likeImage.image = momentOptionBar.reusableLikeImage
        momentOptionBar.likeImage.tintColor = UIColor.darkGray
        momentOptionBar.commentsImage.image = momentOptionBar.reusableCommentImage
        momentOptionBar.commentsImage.tintColor = UIColor.darkGray
        momentOptionBar.bookmarkImage.image = momentOptionBar.reusableBookmarkImage
        momentOptionBar.bookmarkImage.tintColor = UIColor.darkGray
        
        momentOptionBar.likeTextLabel.text = "LIKE"
        momentOptionBar.commentsTextLabel.text = "COMMENT"
        
        return momentOptionBar
    }
    
    func initializeData(moment: Moment) {
        self.momentId = moment.id
        if moment.likersNumber == 0 {
            self.likeTextLabel.text = "LIKE"
        } else {
            self.likeTextLabel.text = "\(moment.likersNumber)"
        }
        
//        self.
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        print("== like button pressed.")
        if self.liked == false {
            MomentManager.sharedInstance.castVoteToAMoment(momentId: self.momentId!, voteType: .typeLike, commit: true, completion: {
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.likeImage.frame = CGRect(x: 12.0, y: 12.0, width: 0.0, height: 0.0)
                }, completion: { (success) in
                    self.likeImage.frame = CGRect(x: 12.0, y: 12.0, width: 0.0, height: 0.0)
                    self.likeImage.image = self.reusableLikedImage
                    self.likeImage.tintColor = UIColor.red
                    UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 2.0, options: [.curveEaseIn], animations: {
                        self.likeImage.frame = CGRect(x: 2.0, y: 2.0, width: 20.0, height: 20.0)
                    }, completion: nil)
                })
            }, errorHandler: {
                print("Unable to cast LIKE vote.")
            })
            
            self.liked = true
        } else {
            MomentManager.sharedInstance.castVoteToAMoment(momentId: self.momentId!, voteType: .typeLike, commit: false, completion: {
                
                self.likeImage.image = self.reusableLikeImage
                self.likeImage.tintColor = UIColor.darkGray
            }, errorHandler: {
                print("Unable to revoke LIKE vote.")
            })
            
            self.liked = false
        }
    }
    
    @IBAction func commentButtonPressed(_ sender: UIButton) {
        print("== comment button pressed.")
    }
    
    @IBAction func bookmarkButtonPressed(_ sender: UIButton) {
        print("== bookmark button pressed.")
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
