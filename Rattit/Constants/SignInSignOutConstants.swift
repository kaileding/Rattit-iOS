//
//  SignInSignOutEnums.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

public enum SignInSignUpContinueType: Int {
    case continueWithGoogle
    case continueWithWechat
    case continueBySigningIn
    case continueBySigningUp
    case continueAsVisitor
}

public enum SignInSignUpNotificationName: String {
    case successfulSignUpWithEmail
    case successfulSignInWithEmail
    case successfulSignInWithGoogle
    case successfulSignInWithWechat
}
