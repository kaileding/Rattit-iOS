//
//  ReusableUserCellDelegate.swift
//  Rattit
//
//  Created by DINGKaile on 7/7/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

protocol ReusableUserCellDelegate: class {
    func tappedUserAvatarOfCell(userId: String)
    func tappedFollowButtonOfCell(userId: String, toFollow: Bool)
}
