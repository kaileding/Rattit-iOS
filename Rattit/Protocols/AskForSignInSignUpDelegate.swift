//
//  AskForSignInSignUpDelegate.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

protocol AskForSignInSignUpDelegate: class {
    func decidedToContinueWith(continueType: SignInSignUpContinueType)
}
