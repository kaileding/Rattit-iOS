//
//  ContentOperationConstants.swift
//  Rattit
//
//  Created by DINGKaile on 6/24/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

public enum ComposeContentNotificationName: String {
    case composeImage = "ComposeImageNotification"
    case composeMoment = "ComposeMomentNotification"
}

public enum followVCContentType: Int {
    case follower
    case following
    case friends
}
