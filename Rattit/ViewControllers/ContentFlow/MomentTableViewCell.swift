//
//  MomentTableViewCell.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class MomentTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var momentWordsLabel: UILabel!
    
//    var networkService: Network = Network()
    
    var moment: Moment! {
        didSet {
            if let createdBy = moment.createdBy {
                RattitUserManager.getRattitUserAvatarImage(userId: createdBy, completion: { (avatarImage) in
                    self.userImage.image = avatarImage
                }, errorHandler: { (error) in
                    print("user has no image")
                    self.userImage.image = UIImage(named: "owlAvatar")
                })
            }
            if let userName = moment.createdByInfo?.userName {
                self.userNameLabel.text = userName
            }
            
            self.titleLabel.text = moment.title
            self.momentWordsLabel.text = moment.words
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // UI Initialization code
        
        self.momentWordsLabel.numberOfLines = 3
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func tappedMomentWordsLabel() {
        self.momentWordsLabel.numberOfLines = 0
    }
    
    
    
    
    
    
}
