//
//  ReusableFriendProfileHeaderView.swift
//  Rattit
//
//  Created by DINGKaile on 7/24/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ReusableFriendProfileHeaderView: UIView {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarImageButton: UIButton!
    
    @IBOutlet weak var realNameLabel: UILabel!
    
    @IBOutlet weak var followerNumLabel: UILabel!
    @IBOutlet weak var followersButton: UIButton!
    
    @IBOutlet weak var followingsNumLabel: UILabel!
    @IBOutlet weak var followingsButton: UIButton!
    
    @IBOutlet weak var organizationIconImageView: UIImageView!
    @IBOutlet weak var organizationLabel: UILabel!
    
    @IBOutlet weak var introTitleLabel: UILabel!
    @IBOutlet weak var manifestoLabel: UILabel!
    
    @IBOutlet weak var followActionButtonView: ReusableFollowingButtonView!
    
    var userId: String!
    
    var imageTappingHandler: (() -> Void)? = nil
    var followerViewTappingHandler: (() -> Void)? = nil
    var followingViewTappingHandler: (() -> Void)? = nil
    
    
    override func awakeFromNib() {
        let friendProfileHeaderView = Bundle.main.loadNibNamed("ReusableFriendProfileHeaderView", owner: self, options: nil)?.first as! UIView
        
        friendProfileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        self.avatarImageView.layer.cornerRadius = 38.0
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.contentMode = .scaleAspectFill
        
        self.organizationIconImageView.image = UIImage(named: "organization")?.withRenderingMode(.alwaysTemplate)
        self.organizationIconImageView.tintColor = UIColor.darkGray
        
        self.introTitleLabel.text = "Intro:"
        
        self.avatarImageButton.addTarget(self, action: #selector(avatarImageTapped), for: .touchUpInside)
        self.followersButton.addTarget(self, action: #selector(followerViewTapped), for: .touchUpInside)
        self.followingsButton.addTarget(self, action: #selector(followingViewTapped), for: .touchUpInside)
        
        self.addSubview(friendProfileHeaderView)
        
        friendProfileHeaderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        friendProfileHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        friendProfileHeaderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        friendProfileHeaderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
    }
    
    static func instantiateFromXib(buttonImageName: String) -> ReusableFriendProfileHeaderView {
        let friendProfileHeaderView = Bundle.main.loadNibNamed("ReusableFriendProfileHeaderView", owner: self, options: nil)?.first as! ReusableFriendProfileHeaderView
        
        return friendProfileHeaderView
    }
    
    
    func initializeData(userId: String) {
        
        self.userId = userId
        RattitUserManager.sharedInstance.getRattitUserAvatarImage(userId: userId, completion: { (image) in
            
            self.avatarImageView.image = image
        }) { (error) in
            print("Unable to get avatar image for user \(userId)")
            self.avatarImageView.image = UIImage(named: "lazyOwl")?.withRenderingMode(.alwaysTemplate)
        }
        
        RattitUserManager.sharedInstance.getRattitUserForId(id: userId, completion: { (user) in
            
            self.realNameLabel.text = "\(user.lastName.uppercased()), \(user.firstName)"
            self.followerNumLabel.text = "\(user.followerNumber)"
            self.followingsNumLabel.text = "\(user.followeeNumber)"
            self.organizationLabel.text = (user.organization.first != nil) ? "\(user.organization.first!)" : " "
            self.manifestoLabel.text = "\(user.manifesto)"
            
        }) { (error) in
            print("Unable to get user for id = \(userId)")
        }
        
        let isFollowingThisUser = UserStateManager.sharedInstance.dummyMyFollowees.contains(userId)
        self.followActionButtonView.initializeData(userId: userId, isFollowing: isFollowingThisUser)
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
    
}
