//
//  PickedUserTogetherWithView.swift
//  Rattit
//
//  Created by DINGKaile on 7/3/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class PickedUserTogetherWithView: UIView {
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var disableIconImageView: UIImageView!
    
    @IBOutlet weak var surfaceButton: UIButton!
    
    var userId: String? = nil
    
    static func instantiateFromXib() -> PickedUserTogetherWithView {
        let pickedUserTogetherWithView = Bundle.main.loadNibNamed("PickedUserTogetherWithView", owner: self, options: nil)?.first as! PickedUserTogetherWithView
        
        pickedUserTogetherWithView.userAvatarImageView.layer.cornerRadius = 23.0
        pickedUserTogetherWithView.userAvatarImageView.contentMode = .scaleAspectFill
        pickedUserTogetherWithView.userAvatarImageView.clipsToBounds = true
        
        pickedUserTogetherWithView.disableIconImageView.image = UIImage(named: "disableIcon")?.withRenderingMode(.alwaysTemplate)
        pickedUserTogetherWithView.disableIconImageView.tintColor = UIColor.red
        
        pickedUserTogetherWithView.surfaceButton.addTarget(pickedUserTogetherWithView, action: #selector(surfaceButtonPressed), for: .touchUpInside)
        
        return pickedUserTogetherWithView
    }
    
    func initializeData(userId: String) {
        self.userId = userId
        
        RattitUserManager.sharedInstance.getRattitUserForId(id: userId, completion: { (user) in
            self.userNameLabel.text = user.userName
        }) { (error) in
            print("Unable to getRattitUserFroId: \(userId). error is \(error.localizedDescription)")
        }
        RattitUserManager.sharedInstance.getRattitUserAvatarImage(userId: userId, completion: { (image) in
            self.userAvatarImageView.image = image
        }) { (error) in
            print("Unable to getRattitUserAvatarImage forId: \(userId). error is \(error.localizedDescription)")
        }
    }
    
    func surfaceButtonPressed() {
        print("surfaceButtonPressed for item: \(self.userNameLabel.text!)")
        ComposeContentManager.sharedInstance.removeUserFromSelectedGroup(userId: self.userId!)
    }
    
}
