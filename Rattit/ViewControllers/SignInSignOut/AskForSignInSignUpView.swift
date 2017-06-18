//
//  AskForSignInSignUpView.swift
//  Rattit
//
//  Created by DINGKaile on 6/18/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class AskForSignInSignUpView: UIView {

    @IBOutlet weak var continueWithGoogleView: UIView!
    @IBOutlet weak var continueWithWechatView: UIView!
    @IBOutlet weak var continueBySigningInView: UIView!
    
    @IBOutlet weak var signUpWithEmailButton: UIButton!
    @IBOutlet weak var continueAsVisitorButton: UIButton!
    
    weak var askForSignInSignUpDelegate: AskForSignInSignUpDelegate?
    
    static func instantiateFromXib() -> AskForSignInSignUpView {
        let askForSignInView = Bundle.main.loadNibNamed("AskForSignInSignUpView", owner: self, options: nil)?.first as! AskForSignInSignUpView
        askForSignInView.initializeItself()
        
        return askForSignInView
    }
    
    func initializeItself() {
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        
        self.signUpWithEmailButton.addTarget(self, action: #selector(pressedSignUpWithEmailButton), for: .touchUpInside)
        self.continueAsVisitorButton.addTarget(self, action: #selector(pressedContinueAsVisitorButton), for: .touchUpInside)
        
        self.continueWithGoogleView.layer.cornerRadius = 3.0
        self.continueWithGoogleView.layer.masksToBounds = true
        self.continueWithWechatView.layer.cornerRadius = 3.0
        self.continueWithWechatView.layer.masksToBounds = true
        self.continueBySigningInView.layer.cornerRadius = 3.0
        self.continueBySigningInView.layer.masksToBounds = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func tappedContinueWIthGoogle(_ sender: UITapGestureRecognizer) {
        print("tappedContinueWIthGoogle. ")
        askForSignInSignUpDelegate?.decidedToContinueWith(continueType: .continueWithGoogle)
    }
    
    @IBAction func tappedContinueWithWechat(_ sender: UITapGestureRecognizer) {
        print("tappedContinueWithWechat. ")
        askForSignInSignUpDelegate?.decidedToContinueWith(continueType: .continueWithWechat)
    }
    
    @IBAction func tappedContinueBySigningIn(_ sender: UITapGestureRecognizer) {
        print("tappedContinueBySigningIn. ")
        askForSignInSignUpDelegate?.decidedToContinueWith(continueType: .continueBySigningIn)
    }
    
    func pressedSignUpWithEmailButton() {
        print("pressedSignUpWithEmailButton. ")
        askForSignInSignUpDelegate?.decidedToContinueWith(continueType: .continueBySigningUp)
    }
    
    func pressedContinueAsVisitorButton() {
        print("pressedContinueAsVisitorButton. ")
        askForSignInSignUpDelegate?.decidedToContinueWith(continueType: .continueAsVisitor)
        self.removeFromSuperview()
    }
    
}
