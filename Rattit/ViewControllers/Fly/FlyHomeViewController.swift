//
//  FlyHomeViewController.swift
//  Rattit
//
//  Created by DINGKaile on 7/4/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class FlyHomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var outerScrollView: UIScrollView!
    
    var userProfileHeaderView: UserProfileHeaderView = UserProfileHeaderView.instantiateFromXib()
    var slideMenuBarView: SlidingTabMenuBarView = SlidingTabMenuBarView.instantiateFromXib()
    var contentDisplayView: UIView? = nil
    
    var hSwipeStartPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var enableHSwipe: Bool = false // true if initial abs(velocity.x) > abs(velocity.y)
    var currentPageIndex: Int = 1 // 1, 2 or 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.outerScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.outerScrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        self.outerScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        self.outerScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        self.outerScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
        
        let hSwipeRecognizer = UIPanGestureRecognizer(target: self, action: #selector(hSwipeGestureRecognized(gestureRecognizer:)))
        hSwipeRecognizer.delegate = self
        
        if self.contentDisplayView == nil {
            self.contentDisplayView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 44.0))
            self.contentDisplayView!.translatesAutoresizingMaskIntoConstraints = false
            self.contentDisplayView!.backgroundColor = UIColor.cyan
            self.contentDisplayView?.addGestureRecognizer(hSwipeRecognizer)
        }
        self.outerScrollView.addSubview(self.userProfileHeaderView)
        self.outerScrollView.addSubview(self.slideMenuBarView)
        self.outerScrollView.addSubview(self.contentDisplayView!)
        
        self.userProfileHeaderView.topAnchor.constraint(equalTo: self.outerScrollView.topAnchor, constant: 0.0).isActive = true
        self.userProfileHeaderView.leadingAnchor.constraint(equalTo: self.outerScrollView.leadingAnchor, constant: 0.0).isActive = true
        self.userProfileHeaderView.trailingAnchor.constraint(equalTo: self.outerScrollView.trailingAnchor, constant: 0.0).isActive = true
        self.userProfileHeaderView.widthAnchor.constraint(equalTo: self.outerScrollView.widthAnchor, constant: 0.0).isActive = true
        
        self.slideMenuBarView.topAnchor.constraint(equalTo: self.userProfileHeaderView.bottomAnchor, constant: 0.0).isActive = true
        self.slideMenuBarView.leadingAnchor.constraint(equalTo: self.outerScrollView.leadingAnchor, constant: 0.0).isActive = true
        self.slideMenuBarView.trailingAnchor.constraint(equalTo: self.outerScrollView.trailingAnchor, constant: 0.0).isActive = true
        self.slideMenuBarView.widthAnchor.constraint(equalTo: self.outerScrollView.widthAnchor, constant: 0.0).isActive = true
        self.slideMenuBarView.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        self.currentPageIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let selfUser = UserStateManager.sharedInstance.dummyUser
        if let userName = selfUser?.userName {
            self.navigationItem.title = "@"+userName
        } else {
            self.navigationItem.title = "Rattit"
        }
        
        self.userProfileHeaderView.initializeData(userId: UserStateManager.sharedInstance.dummyUserId)
        self.userProfileHeaderView.sizeToFit()
        self.outerScrollView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        
        let totalWidth = self.view.frame.width
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.height
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        let profileHeaderHeight = self.userProfileHeaderView.frame.height
        self.outerScrollView.contentSize = CGSize(width: totalWidth, height: (self.outerScrollView.bounds.height-statusBarHeight-navBarHeight!-tabBarHeight!))
        let outerScrollHeight = self.outerScrollView.contentSize.height
        self.contentDisplayView?.frame = CGRect(x: 0.0, y: (profileHeaderHeight+35.0), width: totalWidth, height: (outerScrollHeight-35.0-profileHeaderHeight))
        
        self.slideMenuBarView.initializeSliderPostion(pos: self.currentPageIndex)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("self.outerScrollView.frame is ", self.outerScrollView.frame.debugDescription)
        print("self.outerScrollView.contentSize is ", self.outerScrollView.contentSize.debugDescription)
        print("self.userProfileHeaderView.frame is ", self.userProfileHeaderView.frame.debugDescription)
        print("self.slideMenuBarView.frame is ", self.slideMenuBarView.frame.debugDescription)
        print("self.contentDisplayView.frame is ", self.contentDisplayView!.frame.debugDescription)
//        self.userProfileHeaderView.displaySubviewFrames()
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
    
    func hSwipeGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.contentDisplayView!)
        let velocity = gestureRecognizer.velocity(in: self.contentDisplayView)
        
        let displacementX = self.hSwipeStartPoint.x - translation.x
//        let displacementY = self.hSwipeStartPoint.y - translation.y
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            self.hSwipeStartPoint = translation
            self.enableHSwipe = (abs(velocity.x) > abs(velocity.y))
        } else if gestureRecognizer.state == UIGestureRecognizerState.changed {
//            print("Disaplacement: dx=\(displacementX), dy=\(displacementY)")
            if self.enableHSwipe {
                let ratio = displacementX/(self.view.frame.width)
                self.slideMenuBarView.moveSlider(ratio: ratio)
            }
        } else if gestureRecognizer.state == UIGestureRecognizerState.ended {
            if self.enableHSwipe {
                let totalWidth = self.view.frame.width
                if velocity.x < -250.0 {
                    print("go right to next page, velocity.x = \(velocity.x)")
                    self.continueSlideToRight()
                } else if velocity.x > 250.0 {
                    print("go left to next page, velocity.x = \(velocity.x)")
                    self.continueSlideToLeft()
                } else {
                    if displacementX < -0.5*totalWidth {
                        print("Continue to go left")
                        self.continueSlideToLeft()
                    } else if displacementX > 0.5*totalWidth {
                        print("Continue to go right")
                        self.continueSlideToRight()
                    } else {
                        print("Return back to center")
                        self.slideMenuBarView.animateSlidingToPos(pos: self.currentPageIndex)
                    }
                }
            }
        }
    }
    
    func continueSlideToLeft() {
        self.currentPageIndex -= 1
        if self.currentPageIndex == 0 {
            self.currentPageIndex = 1
        }
        self.slideMenuBarView.animateSlidingToPos(pos: self.currentPageIndex)
    }
    
    func continueSlideToRight() {
        self.currentPageIndex += 1
        if self.currentPageIndex == 4 {
            self.currentPageIndex = 3
        }
        self.slideMenuBarView.animateSlidingToPos(pos: self.currentPageIndex)
    }
}
