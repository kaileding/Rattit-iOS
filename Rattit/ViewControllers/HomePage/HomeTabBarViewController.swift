//
//  HomeTabBarViewController.swift
//  Rattit
//
//  Created by DINGKaile on 6/17/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var blurContentEffectView: UIVisualEffectView?
    var askForSignInView: AskForSignInSignUpView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let contentFlowSB: UIStoryboard = UIStoryboard(name: "ContentFlow", bundle: nil)
        let contentFlowNavVC = contentFlowSB.instantiateViewController(withIdentifier: "ContentFlowNavigationVC") as UIViewController
        contentFlowNavVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "contentTab")?.withRenderingMode(.alwaysTemplate), tag: 0)
        
        let searchSB: UIStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let searchNavVC = searchSB.instantiateViewController(withIdentifier: "SearchNavigationVC") as UIViewController
        searchNavVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "searchTab")?.withRenderingMode(.alwaysTemplate), tag: 1)
        
        let loveSB: UIStoryboard = UIStoryboard(name: "Love", bundle: nil)
        let loveContainerVC = loveSB.instantiateViewController(withIdentifier: "LoveContainerVC") as UIViewController
        loveContainerVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "heartTab")?.withRenderingMode(.alwaysTemplate), tag: 2)
        
        let flySB: UIStoryboard = UIStoryboard(name: "Fly", bundle: nil)
        let flyNavigationVC = flySB.instantiateViewController(withIdentifier: "FlyNavigationVC") as UIViewController
        flyNavigationVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "planeTab")?.withRenderingMode(.alwaysTemplate), tag: 3)
        
        self.viewControllers = [contentFlowNavVC, searchNavVC, loveContainerVC, flyNavigationVC]
        self.selectedIndex = 0
        self.delegate = self
        self.tabBar.tintColor = UIColor.black
        
        NotificationCenter.default.addObserver(self, selector: #selector(signUpOrSignInSuccess), name: NSNotification.Name(SignInSignUpNotificationName.successfulSignUpWithEmail.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showUpSignInAlert), name: NSNotification.Name(SignInSignUpNotificationName.needsToSignInOrSignUp.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showUpComposeImageVC), name: NSNotification.Name(ComposeContentNotificationName.composeImage.rawValue), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (self.blurContentEffectView == nil) {
            let blurContentEffect = UIBlurEffect(style: .dark)
            self.blurContentEffectView = UIVisualEffectView(effect: blurContentEffect)
            self.blurContentEffectView?.alpha = 0.8
            self.blurContentEffectView?.frame = self.view.bounds
        }
        if (self.askForSignInView == nil) {
            self.askForSignInView = AskForSignInSignUpView.instantiateFromXib()
            self.askForSignInView?.frame = CGRect(x: 0.0, y: self.view.bounds.height, width: self.view.bounds.width, height: 234.0)
            self.askForSignInView?.askForSignInSignUpDelegate = self
        }
        
        ComposeContentManager.sharedInstance.initializePhotoLibrary()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeTabBarViewController: AskForSignInSignUpDelegate {
    func decidedToContinueWith(continueType: SignInSignUpContinueType) {
        print("received \(continueType.rawValue) in HomeTabBarViewController. ")
        if (continueType == .continueAsVisitor) {
            UserStateManager.userRefusedToLogin = true
            self.blurContentEffectView?.removeFromSuperview()
        } else if (continueType == .continueBySigningUp) {
            let emailSignInVC = UIStoryboard(name: "SignIn", bundle: nil).instantiateViewController(withIdentifier: "EmailSignUpVC") as! EmailSignUpViewController
            self.present(emailSignInVC, animated: true, completion: nil)
        }
    }
}

extension HomeTabBarViewController {
    func showUpSignInAlert() {
        if (!UserStateManager.showingSignInAlert) {
            self.view.addSubview(self.blurContentEffectView!)
            self.view.addSubview(self.askForSignInView!)
            UserStateManager.showingSignInAlert = true
            UIView.animate(withDuration: 0.7, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 2.0, options: .curveEaseInOut, animations: {
                self.askForSignInView?.center.y -= 226.0
            }, completion: nil)
            
        }
    }
    
    func signUpOrSignInSuccess() {
        // remove askForSignInView
        self.askForSignInView?.removeFromSuperview()
        // remove blurContentEffectView
        self.blurContentEffectView?.removeFromSuperview()
    }
    
    func showUpComposeImageVC() {
        let contentSB = UIStoryboard.init(name: "ContentFlow", bundle: nil)
        let composeImageNavigationVC = contentSB.instantiateViewController(withIdentifier: "ComposeImageNavigationVC") as UIViewController
        self.present(composeImageNavigationVC, animated: true, completion: nil)
    }
}
