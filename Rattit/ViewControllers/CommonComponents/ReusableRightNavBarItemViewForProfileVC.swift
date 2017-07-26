//
//  ReusableRightNavBarItemViewForProfileVC.swift
//  Rattit
//
//  Created by DINGKaile on 7/25/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ReusableRightNavBarItemViewForProfileVC: UIView {
    
    @IBOutlet weak var followButtonView: ReusableFollowingButtonView!
    
    @IBOutlet weak var followButtonViewTopConstraint: NSLayoutConstraint!
    
    
    static func instantiateFromXib(userId: String) -> ReusableRightNavBarItemViewForProfileVC {
        let rightNavBarItemViewForProfileVC = Bundle.main.loadNibNamed("ReusableRightNavBarItemViewForProfileVC", owner: self, options: nil)?.first as! ReusableRightNavBarItemViewForProfileVC
        
        let isFollowingThisUser = UserStateManager.sharedInstance.dummyMyFollowees.contains(userId)
        rightNavBarItemViewForProfileVC.followButtonView.initializeData(userId: userId, isFollowing: isFollowingThisUser)
        
        rightNavBarItemViewForProfileVC.followButtonViewTopConstraint.constant = 5.0
        
        return rightNavBarItemViewForProfileVC
    }
    

}
