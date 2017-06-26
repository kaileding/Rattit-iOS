//
//  ContentFlowRightNavBarItemView.swift
//  Rattit
//
//  Created by DINGKaile on 6/23/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ContentFlowRightNavBarItemView: UIView {
    
    @IBOutlet weak var barItemButton: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static func instantiateFromXib() -> ContentFlowRightNavBarItemView {
        let contentFlowRightNavBarItemView = Bundle.main.loadNibNamed("ContentFlowRightNavBarItemView", owner: self, options: nil)?.first as! ContentFlowRightNavBarItemView
        
        contentFlowRightNavBarItemView.barItemButton.setImage(UIImage(named: "pencil")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        contentFlowRightNavBarItemView.barItemButton.tintColor = UIColor(red: 0.26, green: 0.26, blue: 0.26, alpha: 1.0)
        contentFlowRightNavBarItemView.barItemButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        contentFlowRightNavBarItemView.barItemButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        contentFlowRightNavBarItemView.barItemButton.showsTouchWhenHighlighted = true
        contentFlowRightNavBarItemView.barItemButton.addTarget(contentFlowRightNavBarItemView, action: #selector(barItemButtonPressed), for: .touchUpInside)
        
        return contentFlowRightNavBarItemView
    }
    
    func barItemButtonPressed() {
        print("barItemButtonPressed() func called.")
    }

}
