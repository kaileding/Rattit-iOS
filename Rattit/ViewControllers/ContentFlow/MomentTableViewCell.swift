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
    
    @IBOutlet weak var momentCreatedAtTimeLabel: UILabel!
    
    var imageScrollView: PhotoScrollView? = nil
    
    
    
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
            
            self.momentCreatedAtTimeLabel.text = moment.createdAt?.dateToPostTimeDescription
            self.titleLabel.text = moment.title
            self.momentWordsLabel.text = moment.words
            
            if let photos = moment.photos, photos.count > 0 {
                if self.imageScrollView == nil {
                    
                } else {
                    
                }
            } else if self.imageScrollView != nil {
                self.imageScrollView?.removeFromSuperview()
                self.imageScrollView = nil
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // UI Initialization code
        
        self.userImage.layer.cornerRadius = 15.0
        self.userImage.clipsToBounds = true
        
        self.momentWordsLabel.numberOfLines = 80
        
//        self.imageScrollView
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func tappedMomentWordsLabel() {
        self.momentWordsLabel.numberOfLines = 0
    }
    
    
    
    
    
    
}
