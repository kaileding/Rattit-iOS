//
//  UserProfileHeaderView.swift
//  Rattit
//
//  Created by DINGKaile on 7/4/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class UserProfileHeaderView: UIView {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    
    @IBOutlet weak var numberLabelWrapperView: UIView!
    
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var numberOfFollowingLabel: UILabel!
    @IBOutlet weak var numberOfFriendsLabel: UILabel!
    
    @IBOutlet weak var organizationIconImageView: UIImageView!
    @IBOutlet weak var organizationLabel: UILabel!
    
    @IBOutlet weak var introTitleLabel: UILabel!
    @IBOutlet weak var manifestoLabel: UILabel!
    
    
    static func instantiateFromXib() -> UserProfileHeaderView {
        let userProfileHeaderView = Bundle.main.loadNibNamed("UserProfileHeaderView", owner: self, options: nil)?.first as! UserProfileHeaderView
        
        userProfileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        userProfileHeaderView.userAvatarImageView.layer.cornerRadius = 38.0
        userProfileHeaderView.userAvatarImageView.clipsToBounds = true
        userProfileHeaderView.userAvatarImageView.contentMode = .scaleAspectFill
        
        userProfileHeaderView.organizationIconImageView.image = UIImage(named: "organization")?.withRenderingMode(.alwaysTemplate)
        userProfileHeaderView.organizationIconImageView.tintColor = UIColor.lightGray
//            UIColor(red: 0.1294, green: 0.1137, blue: 0, alpha: 1.0)
            
        userProfileHeaderView.introTitleLabel.text = "Intro:"
        
        return userProfileHeaderView
    }
    
    func initializeData(userId: String) {
        
        RattitUserManager.sharedInstance.getRattitUserAvatarImage(userId: userId, completion: { (image) in
            
            self.userAvatarImageView.image = image
        }) { (error) in
            print("Unable to get avatar image for user \(userId)")
        }
        
        RattitUserManager.sharedInstance.getRattitUserForId(id: userId, completion: { (user) in
            
            self.userFullNameLabel.text = "\(user.lastName.uppercased()), \(user.firstName)"
            self.numberOfFollowersLabel.text = "\(user.followerNumber)"
            self.numberOfFollowingLabel.text = "\(user.followeeNumber)"
            self.numberOfFriendsLabel.text = "0"
            self.organizationLabel.text = (user.organization.first != nil) ? "\(user.organization.first!)" : " "
            self.manifestoLabel.text = "\(user.manifesto)"
            
        }) { (error) in
            print("Unable to get user for id = \(userId)")
        }
    }
    
    func displaySubviewFrames() {
        print("UserProfileHeaderView.userAvatarImageView.frame is \(self.userAvatarImageView.frame.debugDescription)")
        print("UserProfileHeaderView.userFullNameLabel.frame is \(self.userFullNameLabel.frame.debugDescription)")
        print("UserProfileHeaderView.numberLabelWrapperView.frame is \(self.numberLabelWrapperView.frame.debugDescription)")
        
    }
    
}
