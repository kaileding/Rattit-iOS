//
//  MomentHeaderView.swift
//  Rattit
//
//  Created by DINGKaile on 6/22/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class MomentHeaderView: UIView {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var testing_btn: UIButton!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    static func instantiateFromXib() -> MomentHeaderView {
        let momentHeaderView = Bundle.main.loadNibNamed("MomentHeaderView", owner: self, options: nil)?.first as! MomentHeaderView
        
        momentHeaderView.avatarImageView.layer.cornerRadius = 18.0
        momentHeaderView.avatarImageView.clipsToBounds = true
        momentHeaderView.titleLabel.numberOfLines = 0
        
        momentHeaderView.testing_btn.addTarget(momentHeaderView, action: #selector(testingBtnPressed), for: .touchUpInside)
        
        return momentHeaderView
    }
    
    func initializeData(moment: Moment) {
        if let createdBy = moment.createdBy {
            RattitUserManager.getRattitUserAvatarImage(userId: createdBy, completion: { (avatarImage) in
                self.avatarImageView.image = avatarImage
            }, errorHandler: { (error) in
                print("user has no image")
                self.avatarImageView.image = UIImage(named: "owlAvatar")
            })
            
            RattitUserManager.getRattitUserForId(id: createdBy, completion: { (author) in
                self.userNameLabel.text = author.userName
            }, errorHandler: { (error) in
                print("user has no username.")
                self.userNameLabel.text = "alien"
            })
        }
        
        self.titleLabel.text = moment.title
        self.timeStampLabel.text = moment.createdAt?.dateToPostTimeDescription
    }
    
    func testingBtnPressed() {
        print("##--- testing button pressed.")
    }
    
}
