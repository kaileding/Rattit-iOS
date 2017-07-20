//
//  FlyHomeViewNavBarTitleView.swift
//  Rattit
//
//  Created by DINGKaile on 7/20/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class FlyHomeViewNavBarTitleView: UIView {
    
    @IBOutlet weak var topTitleView: UIView!
    @IBOutlet weak var bottomTitleView: UIView!
    
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var bottomTitleLabel: UILabel!
    
    var titleViewHeight: CGFloat = 0.0
    
    static func instantiateFromXib() -> FlyHomeViewNavBarTitleView {
        let flyHomeViewNavBarTitleView = Bundle.main.loadNibNamed("FlyHomeViewNavBarTitleView", owner: self, options: nil)?.first as! FlyHomeViewNavBarTitleView
        
        flyHomeViewNavBarTitleView.translatesAutoresizingMaskIntoConstraints = false
        flyHomeViewNavBarTitleView.topTitleView.translatesAutoresizingMaskIntoConstraints = false
        flyHomeViewNavBarTitleView.bottomTitleView.translatesAutoresizingMaskIntoConstraints = false
        
        return flyHomeViewNavBarTitleView
    }
    
    func initializeData(userName: String, firstName: String) {
        self.topTitleLabel.text = userName
        self.bottomTitleLabel.text = firstName
        self.titleViewHeight = self.topTitleView.frame.height
    }
    
    func slideTitleViews(ratio: CGFloat) {
        self.topTitleView.center.y = (0.5+ratio)*self.titleViewHeight
        self.topTitleView.alpha = 1-ratio
        self.bottomTitleView.center.y = (1.5+ratio)*self.titleViewHeight
        self.bottomTitleView.alpha = -ratio
    }
    
    func continueVerticalSliding() {
        if self.topTitleView.center.y < 0 && self.topTitleView.center.y > -0.5*self.titleViewHeight {
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState, animations: {
                
                self.topTitleView.center.y = -0.5*self.titleViewHeight
                self.topTitleView.alpha = 0
                self.bottomTitleView.center.y = 0.5*self.titleViewHeight
                self.bottomTitleView.alpha = 1
            }, completion: nil)
        } else if self.topTitleView.center.y >= 0
            && self.topTitleView.center.y < 0.5*self.titleViewHeight {
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState, animations: {
                
                self.topTitleView.center.y = 0.5*self.titleViewHeight
                self.topTitleView.alpha = 1
                self.bottomTitleView.center.y = 1.5*self.titleViewHeight
                self.bottomTitleView.alpha = 0
            }, completion: nil)
        }
    }
}
