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
    
    var userId: String!
    var currentRatio: CGFloat = 0
    
    static func instantiateFromXib(userId: String) -> ReusableRightNavBarItemViewForProfileVC {
        let rightNavBarItemViewForProfileVC = Bundle.main.loadNibNamed("ReusableRightNavBarItemViewForProfileVC", owner: self, options: nil)?.first as! ReusableRightNavBarItemViewForProfileVC
        
        rightNavBarItemViewForProfileVC.userId = userId
        let isFollowingThisUser = UserStateManager.sharedInstance.dummyMyFollowees.contains(userId)
        rightNavBarItemViewForProfileVC.followButtonView.initializeData(userId: userId, isFollowing: isFollowingThisUser)
        
        rightNavBarItemViewForProfileVC.followButtonViewTopConstraint.constant = 5.0+34.0
        rightNavBarItemViewForProfileVC.followButtonView.alpha = 0
        
        return rightNavBarItemViewForProfileVC
    }
    
    func setStatus() {
        
        let isFollowingThisUser = UserStateManager.sharedInstance.dummyMyFollowees.contains(self.userId)
        self.followButtonView.initializeData(userId: self.userId, isFollowing: isFollowingThisUser)
    }
    
    
    func slideButtonViews(ratio: CGFloat) {
        self.currentRatio = ratio
//        print("ratio = ", ratio)
        if ratio < -0.5 {
            self.followButtonViewTopConstraint.constant = 5.0+2.0*(1.0+ratio)*34.0
            self.followButtonView.alpha = -ratio
            self.layoutIfNeeded()
        }
    }
    
    func continueVerticalSliding() {
        if self.currentRatio < -0.5 { // should go up
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState, animations: {
                
                self.followButtonViewTopConstraint.constant = 5.0
                self.followButtonView.alpha = 1
                self.layoutIfNeeded()
            }, completion: nil)
        } else { // should go down
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState, animations: {
                
                self.followButtonViewTopConstraint.constant = 5.0+34.0
                self.followButtonView.alpha = 0
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }

}
