//
//  SlideTableHeaderDelegate.swift
//  Rattit
//
//  Created by DINGKaile on 7/25/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

protocol SlideTableHeaderDelegate: class {
    var profileHeaderTopConstraint: NSLayoutConstraint! { get set }
    var profileHeaderHeight: CGFloat { get set }
    
    func resizeTableHeaderViewHeight(step: CGFloat)
    func continueVerticalSliding()
}
