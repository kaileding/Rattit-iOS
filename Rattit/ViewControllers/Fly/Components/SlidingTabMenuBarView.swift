//
//  SlidingTabMenuBarView.swift
//  Rattit
//
//  Created by DINGKaile on 7/5/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class SlidingTabMenuBarView: UIView {
    
    @IBOutlet weak var menuTab1OutView: UIView!
    @IBOutlet weak var menuTab1Button: UIButton!
    
    @IBOutlet weak var menuTab2OutView: UIView!
    @IBOutlet weak var menuTab2Button: UIButton!
    
    @IBOutlet weak var menuTab3OutView: UIView!
    @IBOutlet weak var menuTab3Button: UIButton!
    
    @IBOutlet weak var slidingBarView: UIView!
    
    var sliderTopSpacing: CGFloat = 0.0
    var sliderPos1Width: CGFloat = 0.0
    var sliderPos2Width: CGFloat = 0.0
    var sliderPos3Width: CGFloat = 0.0
    var sliderPos1LeadingSpace: CGFloat = 0.0
    var sliderPos2LeadingSpace: CGFloat = 0.0
    var sliderPos3LeadingSpace: CGFloat = 0.0
    var sliderPositionIndex: Int = 1 // 1, 2 or 3
    
    var bottomBorderAdded: Bool = false
    
    var tabMenuButtonHandler: ((Int) -> Void)? = nil
    
    override func awakeFromNib() {
        let slidingTabMenuBarView = Bundle.main.loadNibNamed("SlidingTabMenuBarView", owner: self, options: nil)?.first as! UIView
        
        slidingTabMenuBarView.translatesAutoresizingMaskIntoConstraints = false
        
        self.menuTab1Button.setTitle("moments", for: .normal)
        self.menuTab1Button.setTitleColor(UIColor.darkGray, for: .normal)
        self.menuTab1Button.setTitleColor(UIColor.lightGray, for: .highlighted)
        self.menuTab1Button.tag = 1
        self.menuTab2Button.setTitle("questions", for: .normal)
        self.menuTab2Button.setTitleColor(UIColor.darkGray, for: .normal)
        self.menuTab2Button.setTitleColor(UIColor.lightGray, for: .highlighted)
        self.menuTab2Button.tag = 2
        self.menuTab3Button.setTitle("answers", for: .normal)
        self.menuTab3Button.setTitleColor(UIColor.darkGray, for: .normal)
        self.menuTab3Button.setTitleColor(UIColor.lightGray, for: .highlighted)
        self.menuTab3Button.tag = 3
        
        self.menuTab1Button.addTarget(self, action: #selector(tabMenuButtonPressed(sender:)), for: .touchUpInside)
        self.menuTab2Button.addTarget(self, action: #selector(tabMenuButtonPressed(sender:)), for: .touchUpInside)
        self.menuTab3Button.addTarget(self, action: #selector(tabMenuButtonPressed(sender:)), for: .touchUpInside)
        
        self.addSubview(slidingTabMenuBarView)
        
        slidingTabMenuBarView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        slidingTabMenuBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        slidingTabMenuBarView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        slidingTabMenuBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
    }
    
    static func instantiateFromXib() -> SlidingTabMenuBarView {
        let slidingTabMenuBarView = Bundle.main.loadNibNamed("SlidingTabMenuBarView", owner: self, options: nil)?.first as! SlidingTabMenuBarView
        
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
    
    func initializeSliderPostion(pos: Int) {
        self.sliderPos1Width = self.menuTab1Button.titleLabel!.frame.width
        self.sliderPos2Width = self.menuTab2Button.titleLabel!.frame.width
        self.sliderPos3Width = self.menuTab3Button.titleLabel!.frame.width
        self.sliderTopSpacing = self.frame.height - 3.0
        self.sliderPos1LeadingSpace = self.menuTab1Button.titleLabel!.frame.minX + self.menuTab1OutView.frame.minX
        self.sliderPos2LeadingSpace = self.menuTab2Button.titleLabel!.frame.minX + self.menuTab2OutView.frame.minX
        self.sliderPos3LeadingSpace = self.menuTab3Button.titleLabel!.frame.minX + self.menuTab3OutView.frame.minX
            
        self.sliderPositionIndex = pos
        switch pos {
        case 1:
            self.slidingBarView.frame = CGRect(x: self.sliderPos1LeadingSpace, y: self.sliderTopSpacing, width: self.sliderPos1Width, height: 3.0)
        case 2:
            self.slidingBarView.frame = CGRect(x: self.sliderPos2LeadingSpace, y: self.sliderTopSpacing, width: self.sliderPos2Width, height: 3.0)
        case 3:
            self.slidingBarView.frame = CGRect(x: self.sliderPos3LeadingSpace, y: self.sliderTopSpacing, width: self.sliderPos3Width, height: 3.0)
        default:
            break
        }
        
        if !self.bottomBorderAdded {
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: 0.0, y: self.frame.height, width: self.frame.width, height: 0.3)
            bottomBorder.backgroundColor = UIColor.lightGray.cgColor
            self.layer.addSublayer(bottomBorder)
            self.bottomBorderAdded = true
        }
    }
    
    func moveSlider(ratio: CGFloat) {
        guard ratio <= 1.0, ratio >= -1.0 else { return }
        
        if ratio < 0 {
            switch self.sliderPositionIndex {
            case 1:
                let newPosX = (1+ratio)*self.sliderPos1LeadingSpace
                let newWidth = (1+ratio)*self.sliderPos1Width
                self.slidingBarView.frame = CGRect(x: newPosX, y: self.sliderTopSpacing, width: newWidth, height: 3.0)
            case 2:
                let newPosX = self.sliderPos2LeadingSpace + ratio*(self.sliderPos2LeadingSpace-self.sliderPos1LeadingSpace)
                let newWidth = self.sliderPos2Width + ratio*(self.sliderPos2Width-self.sliderPos1Width)
                self.slidingBarView.frame = CGRect(x: newPosX, y: self.sliderTopSpacing, width: newWidth, height: 3.0)
            case 3:
                let newPosX = self.sliderPos3LeadingSpace + ratio*(self.sliderPos3LeadingSpace-self.sliderPos2LeadingSpace)
                let newWidth = self.sliderPos3Width + ratio*(self.sliderPos3Width-self.sliderPos2Width)
                self.slidingBarView.frame = CGRect(x: newPosX, y: self.sliderTopSpacing, width: newWidth, height: 3.0)
            default:
                return
            }
        } else if ratio > 0 {
            switch self.sliderPositionIndex {
            case 1:
                let newPosX = self.sliderPos1LeadingSpace + ratio*(self.sliderPos2LeadingSpace-self.sliderPos1LeadingSpace)
                let newWidth = self.sliderPos1Width + ratio*(self.sliderPos2Width-self.sliderPos1Width)
                self.slidingBarView.frame = CGRect(x: newPosX, y: self.sliderTopSpacing, width: newWidth, height: 3.0)
            case 2:
                let newPosX = self.sliderPos2LeadingSpace + ratio*(self.sliderPos3LeadingSpace-self.sliderPos2LeadingSpace)
                let newWidth = self.sliderPos2Width + ratio*(self.sliderPos3Width-self.sliderPos2Width)
                self.slidingBarView.frame = CGRect(x: newPosX, y: self.sliderTopSpacing, width: newWidth, height: 3.0)
            case 3:
                let newPosX = self.sliderPos3LeadingSpace + ratio*(self.frame.width-self.sliderPos3LeadingSpace)
                let newWidth = self.sliderPos3Width - ratio*self.sliderPos3Width
                self.slidingBarView.frame = CGRect(x: newPosX, y: self.sliderTopSpacing, width: newWidth, height: 3.0)
            default:
                return
            }
        }
    }
    
    func animateSlidingToPos(pos: Int) {
        self.sliderPositionIndex = pos
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            switch pos {
            case 1:
                self.slidingBarView.frame = CGRect(x: self.sliderPos1LeadingSpace, y: self.sliderTopSpacing, width: self.sliderPos1Width, height: 3.0)
            case 2:
                self.slidingBarView.frame = CGRect(x: self.sliderPos2LeadingSpace, y: self.sliderTopSpacing, width: self.sliderPos2Width, height: 3.0)
            case 3:
                self.slidingBarView.frame = CGRect(x: self.sliderPos3LeadingSpace, y: self.sliderTopSpacing, width: self.sliderPos3Width, height: 3.0)
            default:
                break
            }
        }, completion: { (success) in
            print("animation of sliding bar to pos \(pos) is success: \(success)")
        })
        
    }
    
    func setTabMenuTappingHandler(task: @escaping (Int) -> Void) {
        self.tabMenuButtonHandler = { (menuIndex: Int) in
            task(menuIndex)
        }
    }
    
    func tabMenuButtonPressed(sender: UIButton) {
        print("tabMenuButtonPressed() func called. sender.tag is \(sender.tag)")
        self.animateSlidingToPos(pos: sender.tag)
        if self.tabMenuButtonHandler != nil {
            self.tabMenuButtonHandler!(sender.tag)
        }
    }
}
