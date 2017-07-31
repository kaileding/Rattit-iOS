//
//  MomentDetailsTableViewCell.swift
//  Rattit
//
//  Created by DINGKaile on 7/30/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class MomentDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var momentTitleLabel: UILabel!
    @IBOutlet weak var momentWordsLabel: UILabel!
    
    @IBOutlet weak var photoSetView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var optionBarView: UIView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeImageButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentsImageView: UIImageView!
    @IBOutlet weak var commentsImageButton: UIButton!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var bookmarkImageView: UIImageView!
    @IBOutlet weak var bookmarkImageButton: UIButton!
    
    
    @IBOutlet weak var photoSetViewHeightConstraint: NSLayoutConstraint!
    
    var userId: String? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.avatarImageView.layer.cornerRadius = 21.0
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.contentMode = .scaleAspectFill
        self.photoSetViewHeightConstraint.constant = 0
    }
    
    func initializeData(moment: Moment) {
        
        if let createdBy = moment.createdBy {
            self.userId = createdBy
            RattitUserManager.sharedInstance.getRattitUserAvatarImage(userId: createdBy, completion: { (avatarImage) in
                self.avatarImageView.image = avatarImage
            }, errorHandler: { (error) in
                print("user has no image")
                self.avatarImageView.image = UIImage(named: "owlAvatar")
            })
            
            RattitUserManager.sharedInstance.getRattitUserForId(id: createdBy, completion: { (author) in
                self.userNameLabel.text = "@"+author.userName
                self.fullNameLabel.text = author.firstName + " " + author.lastName
            }, errorHandler: { (error) in
                print("user has no username.")
                self.userNameLabel.text = "alien"
                self.fullNameLabel.text = "alien"
            })
        }
        
        self.momentTitleLabel.text = moment.title
        self.momentWordsLabel.text = moment.words
        self.dateLabel.text = moment.createdAt?.dateToPostTimeDescription
        
        if moment.likersNumber == 0 {
            self.likeLabel.text = "LIKE"
        } else {
            self.likeLabel.text = "\(moment.likersNumber)"
        }
        
        if let photos = moment.photos, photos.count > 0 {
            self.setupImagesInView(photos: photos)
        } else {
            self.photoSetViewHeightConstraint.constant = 0
            self.photoSetView.subviews.forEach({ (subView) in
                subView.removeFromSuperview()
            })
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MomentDetailsTableViewCell {
    
    func setupImagesInView(photos: [Photo]) {
        var sideLength: CGFloat = AppInfoManager.screenWidth
        var numPerRow: Int = 1
        
        if photos.count == 1 {
            sideLength = AppInfoManager.screenWidth-10.0
            numPerRow = 1
            self.photoSetViewHeightConstraint.constant = sideLength+10.0
        } else if photos.count == 2 {
            sideLength = (AppInfoManager.screenWidth-15.0)/2.0
            numPerRow = 2
            self.photoSetViewHeightConstraint.constant = sideLength+10.0
        } else {
            sideLength = (AppInfoManager.screenWidth-20.0)/3.0
            numPerRow = 3
            if photos.count/3 == 0 {
                self.photoSetViewHeightConstraint.constant = (sideLength+5.0)*CGFloat(photos.count/3) + 5.0
            } else {
                self.photoSetViewHeightConstraint.constant = (sideLength+5.0)*CGFloat(photos.count/3+1) + 5.0
            }
        }
        
        photos.enumerated().forEach { (offset, photo) in
            
            let imageBtnFrame = CGRect(x: 5.0+(sideLength+5.0)*CGFloat(offset/numPerRow), y: 5.0+(sideLength+5.0)*CGFloat(offset%numPerRow), width: sideLength, height: sideLength)
            let imageBtn = UIButton(frame: imageBtnFrame)
            imageBtn.layer.cornerRadius = 3.0
            imageBtn.clipsToBounds = true
            imageBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            imageBtn.imageView?.contentMode = .scaleAspectFill
            imageBtn.tag = offset
            imageBtn.addTarget(self, action: #selector(tapImageButton(imageBtn:)), for: .touchUpInside)
            self.photoSetView.addSubview(imageBtn)
            
            GalleryManager.getImageFromUrl(imageUrl: photos[0].imageUrl, completion: { (image) in
                imageBtn.setImage(image, for: .normal)
            }, errorHandler: { (error) in
                print("unable to get image, error is ", error.localizedDescription)
            })
            
        }
    }
    
    func tapImageButton(imageBtn: UIButton) {
        print("tapImageButton() func. imageBtn.tag=\(imageBtn.tag)")
    }
}
