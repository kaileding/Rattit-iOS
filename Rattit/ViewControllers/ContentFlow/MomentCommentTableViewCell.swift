//
//  MomentCommentTableViewCell.swift
//  Rattit
//
//  Created by DINGKaile on 8/2/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class MomentCommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarImageButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var wordsLabel: UILabel!
    
    @IBOutlet weak var photoSetView: UIView!
    @IBOutlet weak var photoSetViewHeightConstraint: NSLayoutConstraint!
    var imageTapGestureRecognizer: UITapGestureRecognizer? = nil
    
    var momentCommentId: String? = nil
    var authorId: String? = nil
    var momentComment: CommentForMoment? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatarImageView.layer.cornerRadius = 15.0
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.contentMode = .scaleAspectFill
        self.avatarImageButton.addTarget(self, action: #selector(avatarImagePressed), for: .touchUpInside)
        
        self.photoSetViewHeightConstraint.constant = 0
        self.imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoTapRecognized))
        self.photoSetView.addGestureRecognizer(self.imageTapGestureRecognizer!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeData(momentComment: CommentForMoment, commentFlowDelegate: CommentFlowDelegate) {
        self.momentCommentId = momentComment.id
        self.authorId = momentComment.createdBy
        self.momentComment = momentComment
        
        if let user = momentComment.createdByInfo {
            self.userNameLabel.text = "@"+user.userName
            RattitUserManager.sharedInstance.getRattitUserAvatarImage(userId: user.id!, completion: { (image) in
                
                self.avatarImageView.image = image
            }, errorHandler: { (error) in
                print("Unable to get image for avatar.")
            })
        } else {
            self.userNameLabel.text = "@"
            self.avatarImageView.image = UIImage(named: "owlAvatar")!
        }
        
        self.dateLabel.text = momentComment.createdAt!.dateToPostTimeAbsDescription
        self.wordsLabel.text = momentComment.words
        
        self.photoSetView.subviews.forEach { (subView) in
            subView.removeFromSuperview()
        }
        
        if let photo = momentComment.photos?.first {
            let photoViewWidth = self.photoSetView.frame.width
            self.photoSetViewHeightConstraint.constant = 0.4*photoViewWidth
            let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: photoViewWidth, height: 0.4*photoViewWidth))
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = UIColor.lightGray
            self.photoSetView.addSubview(imageView)
            GalleryManager.getImageFromUrl(imageUrl: photo.imageUrl, completion: { (image) in
                imageView.image = image
            }, errorHandler: { (error) in
                print("Unable to get image")
            })
        } else {
            self.photoSetViewHeightConstraint.constant = 0
        }
    }
    
}

extension MomentCommentTableViewCell {
    func avatarImagePressed() {
        print("MomentCommentTableViewCell.avatarImagePressed() func.")
    }
    
    func photoTapRecognized() {
        print("MomentCommentTableViewCell.imageTapRecognized() func.")
    }
}
