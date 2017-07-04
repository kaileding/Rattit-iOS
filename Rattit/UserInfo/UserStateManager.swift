//
//  UserStateManager.swift
//  Rattit
//
//  Created by DINGKaile on 6/17/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

class UserStateManager: NSObject {
    static var userIsLoggedIn: Bool = false
    static var userRefusedToLogin: Bool = false
    static var showingSignInAlert: Bool = false
    
    static var dummyUserId: String = "e5b89946-4db4-11e7-b114-b2f933d5fe66"
}
