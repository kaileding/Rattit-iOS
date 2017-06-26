//
//  SignInSignOutEnums.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

public enum SignInSignUpContinueType: Int {
    case continueWithGoogle = 0
    case continueWithWechat = 1
    case continueBySigningIn = 2
    case continueBySigningUp = 3
    case continueAsVisitor = 4
}

public enum SignInSignUpNotificationName: String {
    case needsToSignInOrSignUp = "NeedsToSignInOrSignUpNotification"
    case successfulSignUpWithEmail = "SuccessfulSignUpWithEmailNotification"
    case successfulSignInWithEmail = "SuccessfulSignInWithEmailNotification"
    case successfulSignInWithGoogle = "SuccessfulSignInWithGoogleNotification"
    case successfulSignInWithWechat = "SuccessfulSignInWithWechatNotification"
}
