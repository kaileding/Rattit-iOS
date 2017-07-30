//
//  ContentOperationConstants.swift
//  Rattit
//
//  Created by DINGKaile on 6/24/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

public enum ContentOperationNotificationName: String {
    case composeMoment = "ComposeMomentNotification"
    case composeQuestion = "ComposeQuestionNotification"
    case showImagesModal = "ShowModalToDisplayArrayOfImagesNotification"
}

public enum followVCContentType: Int {
    case follower
    case following
    case friends
}


