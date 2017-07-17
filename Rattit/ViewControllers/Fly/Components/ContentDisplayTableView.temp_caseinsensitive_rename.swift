//
//  contentDisplayTableView.swift
//  Rattit
//
//  Created by DINGKaile on 7/17/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class contentDisplayTableView: UIView {

    @IBOutlet weak var contentTableView: UITableView!
    
    
    
    static func instantiateFromXib() -> contentDisplayTableView {
        let contentDisplayTableView = Bundle.main.loadNibNamed("contentDisplayTableView", owner: self, options: nil)?.first as! contentDisplayTableView
        
        slidingTabMenuBarView.translatesAutoresizingMaskIntoConstraints = false
        
        slidingTabMenuBarView.menuTab1Button.setTitle("moments", for: .normal)
        slidingTabMenuBarView.menuTab1Button.setTitleColor(UIColor.darkGray, for: .normal)
        slidingTabMenuBarView.menuTab1Button.setTitleColor(UIColor.lightGray, for: .highlighted)
        slidingTabMenuBarView.menuTab1Button.tag = 1
        slidingTabMenuBarView.menuTab2Button.setTitle("questions", for: .normal)
        slidingTabMenuBarView.menuTab2Button.setTitleColor(UIColor.darkGray, for: .normal)
        slidingTabMenuBarView.menuTab2Button.setTitleColor(UIColor.lightGray, for: .highlighted)
        slidingTabMenuBarView.menuTab2Button.tag = 2
        slidingTabMenuBarView.menuTab3Button.setTitle("answers", for: .normal)
        slidingTabMenuBarView.menuTab3Button.setTitleColor(UIColor.darkGray, for: .normal)
        slidingTabMenuBarView.menuTab3Button.setTitleColor(UIColor.lightGray, for: .highlighted)
        slidingTabMenuBarView.menuTab3Button.tag = 3
        
        slidingTabMenuBarView.menuTab1Button.addTarget(slidingTabMenuBarView, action: #selector(tabMenuButtonPressed(sender:)), for: .touchUpInside)
        slidingTabMenuBarView.menuTab2Button.addTarget(slidingTabMenuBarView, action: #selector(tabMenuButtonPressed(sender:)), for: .touchUpInside)
        slidingTabMenuBarView.menuTab3Button.addTarget(slidingTabMenuBarView, action: #selector(tabMenuButtonPressed(sender:)), for: .touchUpInside)
        
        return slidingTabMenuBarView
    }
    

}
