//
//  AnswerBriefTableViewCell.swift
//  Rattit
//
//  Created by DINGKaile on 8/2/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class AnswerBriefTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarImageButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var wordsLabel: UILabel!
    
    @IBOutlet weak var photoSetView: UIView!
    @IBOutlet weak var photoSetViewHeightConstraint: NSLayoutConstraint!
    
    var answerId: String? = nil
    var authorId: String? = nil
    var answer: Answer? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.avatarImageView.layer.cornerRadius = 15.0
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.contentMode = .scaleAspectFill
        self.avatarImageButton.addTarget(self, action: #selector(avatarImagePressed), for: .touchUpInside)
        
        self.photoSetViewHeightConstraint.constant = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeData(answerId: String, commentFlowDelegate: CommentFlowDelegate) {
        self.answerId = answerId
    }
    
}

extension AnswerBriefTableViewCell {
    func avatarImagePressed() {
        print("MomentCommentTableViewCell.avatarImagePressed() func.")
    }
}
