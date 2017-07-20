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
    @IBOutlet weak var userAvatarButton: UIButton!
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    
    @IBOutlet weak var numberLabelWrapperView: UIView!
    
    @IBOutlet weak var numberOfFollowersLabel: UILabel!
    @IBOutlet weak var numberOfFollowingLabel: UILabel!
    @IBOutlet weak var numberOfFriendsLabel: UILabel!
    
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var friendsButton: UIButton!
    
    @IBOutlet weak var organizationIconImageView: UIImageView!
    @IBOutlet weak var organizationLabel: UILabel!
    
    @IBOutlet weak var introTitleLabel: UILabel!
    @IBOutlet weak var manifestoLabel: UILabel!
    
    var imageTappingHandler: (() -> Void)? = nil
    var followerViewTappingHandler: (() -> Void)? = nil
    var followingViewTappingHandler: (() -> Void)? = nil
    var friendsViewTappingHandler: (() -> Void)? = nil
    
    override func awakeFromNib() {
        let userProfileHeaderView = Bundle.main.loadNibNamed("UserProfileHeaderView", owner: self, options: nil)?.first as! UIView
        
        userProfileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        self.userAvatarImageView.layer.cornerRadius = 38.0
        self.userAvatarImageView.clipsToBounds = true
        self.userAvatarImageView.contentMode = .scaleAspectFill
        
        self.organizationIconImageView.image = UIImage(named: "organization")?.withRenderingMode(.alwaysTemplate)
        self.organizationIconImageView.tintColor = UIColor.darkGray
        
        self.introTitleLabel.text = "Intro:"
        
        self.userAvatarButton.addTarget(self, action: #selector(avatarImageTapped), for: .touchUpInside)
        self.followersButton.addTarget(self, action: #selector(followerViewTapped), for: .touchUpInside)
        self.followingButton.addTarget(self, action: #selector(followingViewTapped), for: .touchUpInside)
        self.friendsButton.addTarget(self, action: #selector(friendsViewTapped), for: .touchUpInside)
        
        self.addSubview(userProfileHeaderView)
        
        userProfileHeaderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        userProfileHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        userProfileHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        userProfileHeaderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
    }
    
    static func instantiateFromXib() -> UserProfileHeaderView {
        let userProfileHeaderView = Bundle.main.loadNibNamed("UserProfileHeaderView", owner: self, options: nil)?.first as! UserProfileHeaderView
        
        userProfileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        userProfileHeaderView.userAvatarImageView.layer.cornerRadius = 38.0
        userProfileHeaderView.userAvatarImageView.clipsToBounds = true
        userProfileHeaderView.userAvatarImageView.contentMode = .scaleAspectFill
        
        userProfileHeaderView.organizationIconImageView.image = UIImage(named: "organization")?.withRenderingMode(.alwaysTemplate)
        userProfileHeaderView.organizationIconImageView.tintColor = UIColor.darkGray
            
        userProfileHeaderView.introTitleLabel.text = "Intro:"
        
        userProfileHeaderView.userAvatarButton.addTarget(userProfileHeaderView, action: #selector(avatarImageTapped), for: .touchUpInside)
        userProfileHeaderView.followersButton.addTarget(userProfileHeaderView, action: #selector(followerViewTapped), for: .touchUpInside)
        userProfileHeaderView.followingButton.addTarget(userProfileHeaderView, action: #selector(followingViewTapped), for: .touchUpInside)
        userProfileHeaderView.friendsButton.addTarget(userProfileHeaderView, action: #selector(friendsViewTapped), for: .touchUpInside)
        
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
            self.organizationLabel.text = (user.organization.first != nil) ? "\(user.organization.first!)" : " "
            self.manifestoLabel.text = "\(user.manifesto)"
            
        }) { (error) in
            print("Unable to get user for id = \(userId)")
        }
        
        RattitUserManager.sharedInstance.getFollowersOrFolloweesOfUser(userId: userId, relationType: .friends, completion: { (totalNum, userGroup) in
            self.numberOfFriendsLabel.text = "\(totalNum)"
        }, errorHandler: { (error) in
            print("Unable to get friends for userId = \(userId)")
        })
        
    }
    
    func displaySubviewFrames() {
        print("UserProfileHeaderView.userAvatarImageView.frame is \(self.userAvatarImageView.frame.debugDescription)")
        print("UserProfileHeaderView.userFullNameLabel.frame is \(self.userFullNameLabel.frame.debugDescription)")
        print("UserProfileHeaderView.numberLabelWrapperView.frame is \(self.numberLabelWrapperView.frame.debugDescription)")
        
    }
    
    func setHandlerForImageTappig(task: @escaping () -> Void) {
        self.imageTappingHandler = {
            task()
        }
    }
    
    func setHandlerForFollowerViewTapping(task: @escaping () -> Void) {
        self.followerViewTappingHandler = {
            task()
        }
    }
    
    func setHandlerForFollowingViewTapping(task: @escaping () -> Void) {
        self.followingViewTappingHandler = {
            task()
        }
    }
    
    func setHandlerForFriendsViewTapping(task: @escaping () -> Void) {
        self.friendsViewTappingHandler = {
            task()
        }
    }
    
    func avatarImageTapped() {
        print("avatarImageTapped() func.")
        if self.imageTappingHandler != nil {
            self.imageTappingHandler!()
        }
    }
    
    func followerViewTapped() {
        print("followerViewTapped() func.")
        if self.followerViewTappingHandler != nil {
            self.followerViewTappingHandler!()
        }
    }
    
    func followingViewTapped() {
        print("followingViewTapped() func.")
        if self.followingViewTappingHandler != nil {
            self.followingViewTappingHandler!()
        }
    }
    
    func friendsViewTapped() {
        print("friendsViewTapped() func.")
        if self.friendsViewTappingHandler != nil {
            self.friendsViewTappingHandler!()
        }
    }
}
