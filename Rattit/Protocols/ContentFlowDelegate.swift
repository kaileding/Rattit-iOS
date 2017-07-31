//
//  ContentFlowDelegate.swift
//  Rattit
//
//  Created by DINGKaile on 7/31/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

protocol ContentFlowDelegate: class {
    func tappedUserAvatarOfCell(userId: String)
    func aContentCellIsSelected(contentId: String, contentType: RattitContentType)
}
