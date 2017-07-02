//
//  ContentFlowLeftNavBarItemView.swift
//  Rattit
//
//  Created by DINGKaile on 6/23/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ContentFlowLeftNavBarItemView: UIView {
    
    @IBOutlet weak var barItemButton: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static func instantiateFromXib() -> ContentFlowLeftNavBarItemView {
        let contentFlowLeftNavBarItemView = Bundle.main.loadNibNamed("ContentFlowLeftNavBarItemView", owner: self, options: nil)?.first as! ContentFlowLeftNavBarItemView
        
        contentFlowLeftNavBarItemView.barItemButton.setImage(UIImage(named: "camera")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        contentFlowLeftNavBarItemView.barItemButton.imageEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        contentFlowLeftNavBarItemView.barItemButton.tintColor = UIColor(red: 0.26, green: 0.26, blue: 0.26, alpha: 1.0)
        contentFlowLeftNavBarItemView.barItemButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        contentFlowLeftNavBarItemView.barItemButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        contentFlowLeftNavBarItemView.barItemButton.showsTouchWhenHighlighted = true
        contentFlowLeftNavBarItemView.barItemButton.addTarget(contentFlowLeftNavBarItemView, action: #selector(barItemButtonPressed), for: .touchUpInside)
        
        return contentFlowLeftNavBarItemView
    }
    
    func barItemButtonPressed() {
        print("left barItemButtonPressed() func called.")
        
        if UserStateManager.userIsLoggedIn || UserStateManager.userRefusedToLogin {
            NotificationCenter.default.post(name: NSNotification.Name(ComposeContentNotificationName.composeImage.rawValue), object: nil, userInfo: nil)
        }
    }
    
}
