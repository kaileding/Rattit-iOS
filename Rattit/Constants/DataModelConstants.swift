//
//  DataModelConstants.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

public enum RattitUserGender: String {
    case male = "male"
    case female = "female"
    case untold = "untold"
}

public enum RattitContentAccessLevel: String {
    case levelSelf = "self"
    case levelFriends = "friends"
    case levelFollowers = "followers"
    case levelPublic = "public"
}
