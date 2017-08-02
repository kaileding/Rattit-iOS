//
//  ReusableUserTableViewCell.swift
//  Rattit
//
//  Created by DINGKaile on 7/7/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ReusableUserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userAvatarImageButton: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userManifestoLabel: UILabel!
    
    @IBOutlet weak var followButtonView: ReusableFollowingButtonView!
    
    
//    @IBOutlet weak var followButton: UIButton!
    
    var userId: String? = nil
    var parentVC: ReusableUserCellDelegate? = nil
//    var isFollowing: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.userAvatarImageView.layer.cornerRadius = 22.0
        self.userAvatarImageView.clipsToBounds = true
        self.userAvatarImageView.contentMode = .scaleAspectFill
        
        self.userAvatarImageButton.addTarget(self, action: #selector(avatarImageTapped), for: .touchUpInside)
        
//        self.followButton.layer.borderWidth = 1.0
//        self.followButton.layer.borderColor = RattitStyleColors.clickableButtonBlue.cgColor
//        self.followButton.layer.cornerRadius = 2.0
//        self.followButton.clipsToBounds = true
//        self.followButton.backgroundColor = RattitStyleColors.backgroundGray
//        self.followButton.addTarget(self, action: #selector(followButtonPressed), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeData(userId: String, parentVC: ReusableUserCellDelegate!) {
        self.userId = userId
        self.parentVC = parentVC
        
        RattitUserManager.sharedInstance.getRattitUserAvatarImage(userId: userId, completion: { (image) in
            self.userAvatarImageView.image = image
        }) { (error) in
            print("unable to get avatar image. Error is \(error.localizedDescription)")
        }
        RattitUserManager.sharedInstance.getRattitUserForId(id: userId, completion: { (user) in
            
            self.userNameLabel.text = user.userName
            self.userFullNameLabel.text = "\(user.lastName.uppercased()), \(user.firstName)"
            self.userManifestoLabel.text = user.manifesto
        }) { (error) in
            print("Unable to get user. Error is \(error.localizedDescription)")
        }
        
        let isFollowingThisUser = UserStateManager.sharedInstance.dummyMyFollowees.contains(userId)
        self.followButtonView.initializeData(userId: userId, isFollowing: isFollowingThisUser)
    }
    
    func avatarImageTapped() {
        print("avatarImageTapped. userId = \(self.userId!), username = \(self.userNameLabel.text!)")
        
        if self.parentVC != nil {
            self.parentVC!.tappedUserAvatarOfCell(userId: self.userId!)
        }
    }
    
    func followButtonPressed() {
        print("followButtonPressed. userId = \(self.userId!), username = \(self.userNameLabel.text!)")
        
//        if self.parentVC != nil {
//            self.parentVC!.tappedFollowButtonOfCell(userId: self.userId!, toFollow: !self.isFollowing)
//        }
    }
}
