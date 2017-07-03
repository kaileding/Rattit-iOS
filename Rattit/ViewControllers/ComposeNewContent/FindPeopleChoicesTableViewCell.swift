//
//  FindPeopleChoicesTableViewCell.swift
//  Rattit
//
//  Created by DINGKaile on 7/2/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class FindPeopleChoicesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userRealNameLabel: UILabel!
    @IBOutlet weak var userManifestoLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    
    var userId: String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.userAvatarImageView.layer.cornerRadius = 22.0
        self.userAvatarImageView.clipsToBounds = true
        self.userAvatarImageView.contentMode = .scaleAspectFill
        
        self.followButton.layer.borderWidth = 1.0
        self.followButton.layer.borderColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1.0).cgColor
        self.followButton.layer.cornerRadius = 2.0
        self.followButton.clipsToBounds = true
        self.followButton.addTarget(self, action: #selector(followButtonPressed), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeData(user: RattitUser) {
        self.userId = user.id
        self.userNameLabel.text = user.userName
        self.userRealNameLabel.text = "\(user.lastName.uppercased()), \(user.firstName)"
        self.userManifestoLabel.text = user.manifesto
        RattitUserManager.sharedInstance.getRattitUserAvatarImage(userId: user.id!, completion: { (image) in
            
            self.userAvatarImageView.image = image
        }) { (error) in
            print("Unable to get userAvatarImage.")
        }
    }
    
    func followButtonPressed() {
        print("followButtonPressed. userId = \(self.userId!), username = \(self.userNameLabel.text!)")
    }
}
