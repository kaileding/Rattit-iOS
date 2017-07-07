//
//  ReusableNavBarItemView.swift
//  Rattit
//
//  Created by DINGKaile on 6/23/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ReusableNavBarItemView: UIView {
    
    @IBOutlet weak var barItemButton: UIButton!
    
    var executionBlock: (() -> Void)? = nil
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static func instantiateFromXib(buttonImageName: String) -> ReusableNavBarItemView {
        let reusableNavBarItemView = Bundle.main.loadNibNamed("ReusableNavBarItemView", owner: self, options: nil)?.first as! ReusableNavBarItemView
        
        reusableNavBarItemView.barItemButton.setImage(UIImage(named: buttonImageName)?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        reusableNavBarItemView.barItemButton.imageEdgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)
        reusableNavBarItemView.barItemButton.tintColor = RattitStyleColors.navBarItemBlack
        reusableNavBarItemView.barItemButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        reusableNavBarItemView.barItemButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        reusableNavBarItemView.barItemButton.showsTouchWhenHighlighted = true
        reusableNavBarItemView.barItemButton.addTarget(reusableNavBarItemView, action: #selector(barItemButtonPressed), for: .touchUpInside)
        
        return reusableNavBarItemView
    }
    
    func setButtonExecutionBlock(task: @escaping () -> Void) {
        self.executionBlock = {
            task()
        }
    }
    
    func barItemButtonPressed() {
        print("barItemButtonPressed() func called.")
        if self.executionBlock != nil {
            self.executionBlock!()
        }
    }

}
