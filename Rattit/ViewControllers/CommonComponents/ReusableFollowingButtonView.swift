//
//  ReusableFollowingButtonView.swift
//  Rattit
//
//  Created by DINGKaile on 7/24/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ReusableFollowingButtonView: UIView {
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var leftViewLeadingConstraint: NSLayoutConstraint!
    
    var userId: String!
    var showingLeft: Bool = true
    var showingLeftConstraint: NSLayoutConstraint!
    var showingRightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        let reusableFollowingButtonView = Bundle.main.loadNibNamed("ReusableFollowingButtonView", owner: self, options: nil)?.first as! UIView
        
        reusableFollowingButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = RattitStyleColors.clickableButtonBlue.cgColor
        self.layer.cornerRadius = 3.0
        self.clipsToBounds = true
        self.leftView.backgroundColor = RattitStyleColors.backgroundGray
        self.leftLabel.textColor = UIColor.darkGray
        self.rightView.backgroundColor = UIColor.white
        self.rightLabel.textColor = RattitStyleColors.clickableButtonBlue
        
        self.showingLeftConstraint = self.leftView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0)
        self.showingRightConstraint = self.rightView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0)
        
        self.followingButton.addTarget(self, action: #selector(followingButtonPressed), for: .touchUpInside)
        
        self.addSubview(reusableFollowingButtonView)
        
        reusableFollowingButtonView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        reusableFollowingButtonView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        reusableFollowingButtonView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        reusableFollowingButtonView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
    }
    
    static func instantiateFromXib() -> ReusableFollowingButtonView {
        let reusableFollowingButtonView = Bundle.main.loadNibNamed("ReusableFollowingButtonView", owner: self, options: nil)?.first as! ReusableFollowingButtonView
        
        reusableFollowingButtonView.leftView.backgroundColor = UIColor.cyan
        reusableFollowingButtonView.rightView.backgroundColor = UIColor.lightGray
        reusableFollowingButtonView.leftLabel.text = "Following"
        reusableFollowingButtonView.rightLabel.text = "Follow"
        
        return reusableFollowingButtonView
    }
    
    func initializeData(userId: String, isFollowing: Bool) {
        self.userId = userId
        self.showingLeft = isFollowing
        self.showingLeftConstraint.isActive = false
        self.showingRightConstraint.isActive = false
        if isFollowing {
            self.showingLeftConstraint.isActive = true
            self.layer.borderColor = UIColor.darkGray.cgColor
        } else {
            self.showingRightConstraint.isActive = true
            self.layer.borderColor = RattitStyleColors.clickableButtonBlue.cgColor
        }
        self.layoutIfNeeded()
    }
    
    func followingButtonPressed() {
        self.showingLeftConstraint.isActive = false
        self.showingRightConstraint.isActive = false
        if self.showingLeft {
            RattitUserManager.sharedInstance.unfollowUser(targetUserId: self.userId, completion: {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.showingRightConstraint.isActive = true
                    self.layer.borderColor = RattitStyleColors.clickableButtonBlue.cgColor
                    self.layoutIfNeeded()
                }, completion: { (success) in
                    self.showingLeft = false
                    print("followingButton slides success: \(success), now showingLeft is \(self.showingLeft)")
                })
            }, errorHandler: { (error) in
                print("Unable to unfollow user.")
            })
        } else {
            RattitUserManager.sharedInstance.followUsers(targetUserIds: [self.userId], completion: {
                UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.showingLeftConstraint.isActive = true
                    self.layer.borderColor = UIColor.darkGray.cgColor
                    self.layoutIfNeeded()
                }, completion: { (success) in
                    self.showingLeft = true
                    print("followingButton slides success: \(success), now showingLeft is \(self.showingLeft)")
                })
            }, errorHandler: { (error) in
                print("Unable to follow user.")
            })
        }
    }

}
