//
//  MainContentHeaderView.swift
//  Rattit
//
//  Created by DINGKaile on 6/22/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class MainContentHeaderView: UIView {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var ActionLabel: UILabel!
    
    @IBOutlet weak var moreButton: UIButton!
    let threeDotsImage: UIImage! = UIImage(named: "threeDots")?.withRenderingMode(.alwaysTemplate)
    let threeSolidDotsImage: UIImage! = UIImage(named: "threeSolidDots")?.withRenderingMode(.alwaysTemplate)
    
    
    static func instantiateFromXib() -> MainContentHeaderView {
        let mainContentHeaderView = Bundle.main.loadNibNamed("MainContentHeaderView", owner: self, options: nil)?.first as! MainContentHeaderView
        
        mainContentHeaderView.avatarImageView.layer.cornerRadius = 18.0
        mainContentHeaderView.avatarImageView.clipsToBounds = true
        mainContentHeaderView.ActionLabel.text = ""
        
        mainContentHeaderView.moreButton.setImage(mainContentHeaderView.threeDotsImage, for: .normal)
        mainContentHeaderView.moreButton.setImage(mainContentHeaderView.threeSolidDotsImage, for: .selected)
        mainContentHeaderView.moreButton.tintColor = UIColor.darkGray
        mainContentHeaderView.moreButton.addTarget(mainContentHeaderView, action: #selector(moreButtonPressed), for: .touchUpInside)
        
        return mainContentHeaderView
    }
    
    func initializeData(mainContent: MainContent, actionStr: String) {
        if let createdBy = mainContent.createdBy {
            RattitUserManager.sharedInstance.getRattitUserAvatarImage(userId: createdBy, completion: { (avatarImage) in
                self.avatarImageView.image = avatarImage
            }, errorHandler: { (error) in
                print("user has no image")
                self.avatarImageView.image = UIImage(named: "owlAvatar")
            })
            self.avatarImageView.contentMode = .scaleAspectFill
            
            RattitUserManager.sharedInstance.getRattitUserForId(id: createdBy, completion: { (author) in
                self.userNameLabel.text = "@"+author.userName
            }, errorHandler: { (error) in
                print("user has no username.")
                self.userNameLabel.text = "alien"
            })
        }
        
        self.timeStampLabel.text = mainContent.createdAt?.dateToPostTimeDescription
        self.ActionLabel.text = actionStr
    }
    
    func moreButtonPressed() {
        print("##--- testing button pressed.")
    }
    
}
