//
//  FlyHomeViewController.swift
//  Rattit
//
//  Created by DINGKaile on 7/4/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class FlyHomeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var outerVisibleView: UIView!
    
    var userProfileHeaderView: UserProfileHeaderView = UserProfileHeaderView.instantiateFromXib()
    var slideMenuBarView: SlidingTabMenuBarView = SlidingTabMenuBarView.instantiateFromXib()
    var contentDisplayView: UIView = UIView()
    var contentViews: [ContentDisplayTableView] = []
    
    // horizontal swipe
    var hSwipeStartPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var enableHSwipe: Bool = false // true if initial abs(velocity.x) > abs(velocity.y)
    var currentPageIndex: Int = 1 // 1, 2 or 3
    
    // vertical swipe
    var profileHeaderTopContraint: NSLayoutConstraint!
    var profileHeaderHeight: CGFloat = 0.0
    var enableVSwipe: Bool = false // true if initial abs(velocity.x) < abs(velocity.y)
    var currentHeaderStateIsTop: Bool = false // true if profileHeaderView is hidden at the top
    
    var segueDestContentType: RattitUserRelationshipType = .follower
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let flyHomePageRightBarButtonItemView = ReusableNavBarItemView.instantiateFromXib(buttonImageName: "settingIcon")
        flyHomePageRightBarButtonItemView.setButtonExecutionBlock {
            self.rightBarButtonPressed()
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: flyHomePageRightBarButtonItemView)
        
        let hSwipeRecognizer = UIPanGestureRecognizer(target: self, action: #selector(hSwipeGestureRecognized(gestureRecognizer:)))
        hSwipeRecognizer.delegate = self
        let vSwipeRecognizer = UIPanGestureRecognizer(target: self, action: #selector(vSwipeGestureRecognized(gestureRecognizer:)))
        vSwipeRecognizer.delegate = self
        
        self.contentDisplayView.translatesAutoresizingMaskIntoConstraints = false
//        self.contentDisplayView.backgroundColor = UIColor.cyan
        self.contentDisplayView.addGestureRecognizer(hSwipeRecognizer)
        self.userProfileHeaderView.addGestureRecognizer(vSwipeRecognizer)
        
        self.outerVisibleView.addSubview(self.userProfileHeaderView)
        self.outerVisibleView.addSubview(self.slideMenuBarView)
        self.outerVisibleView.addSubview(self.contentDisplayView)
        
        self.userProfileHeaderView.setHandlerForFollowerViewTapping {
            self.segueDestContentType = .follower
            self.performSegue(withIdentifier: "FlyHomeToFollowView", sender: self)
        }
        self.userProfileHeaderView.setHandlerForFollowingViewTapping {
            self.segueDestContentType = .followee
            self.performSegue(withIdentifier: "FlyHomeToFollowView", sender: self)
        }
        self.userProfileHeaderView.setHandlerForFriendsViewTapping {
            self.segueDestContentType = .friends
            self.performSegue(withIdentifier: "FlyHomeToFollowView", sender: self)
        }
        
        self.profileHeaderTopContraint = self.userProfileHeaderView.topAnchor.constraint(equalTo: self.outerVisibleView.topAnchor, constant: 0.0)
        self.profileHeaderTopContraint.isActive = true
        self.userProfileHeaderView.leadingAnchor.constraint(equalTo: self.outerVisibleView.leadingAnchor, constant: 0.0).isActive = true
        self.userProfileHeaderView.trailingAnchor.constraint(equalTo: self.outerVisibleView.trailingAnchor, constant: 0.0).isActive = true
        self.userProfileHeaderView.widthAnchor.constraint(equalTo: self.outerVisibleView.widthAnchor, constant: 0.0).isActive = true
        
        self.slideMenuBarView.setTabMenuTappingHandler { (destinationIndex) in
            self.contentDisplayViewJumpToIndex(index: destinationIndex)
        }
        
        self.slideMenuBarView.topAnchor.constraint(equalTo: self.userProfileHeaderView.bottomAnchor, constant: 0.0).isActive = true
        self.slideMenuBarView.leadingAnchor.constraint(equalTo: self.outerVisibleView.leadingAnchor, constant: 0.0).isActive = true
        self.slideMenuBarView.trailingAnchor.constraint(equalTo: self.outerVisibleView.trailingAnchor, constant: 0.0).isActive = true
        self.slideMenuBarView.widthAnchor.constraint(equalTo: self.outerVisibleView.widthAnchor, constant: 0.0).isActive = true
        self.slideMenuBarView.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        self.contentDisplayView.topAnchor.constraint(equalTo: self.slideMenuBarView.bottomAnchor, constant: 0.0).isActive = true
        self.contentDisplayView.leadingAnchor.constraint(equalTo: self.outerVisibleView.leadingAnchor, constant: 0.0).isActive = true
        self.contentDisplayView.trailingAnchor.constraint(equalTo: self.outerVisibleView.trailingAnchor, constant: 0.0).isActive = true
        self.contentDisplayView.bottomAnchor.constraint(equalTo: self.outerVisibleView.bottomAnchor, constant: 0.0).isActive = true
        
        let contentView1 = ContentDisplayTableView.instantiateFromXib()
        contentView1.initializeData(backgroundColor: UIColor(red: 0.2235, green: 0.5882, blue: 0, alpha: 1.0))
        let contentView2 = ContentDisplayTableView.instantiateFromXib()
        contentView2.initializeData(backgroundColor: UIColor(red: 0, green: 0.6, blue: 0.5373, alpha: 1.0))
        let contentView3 = ContentDisplayTableView.instantiateFromXib()
        contentView3.initializeData(backgroundColor: UIColor(red: 0.5569, green: 0, blue: 0.5412, alpha: 1.0))
        self.contentViews.append(contentView1)
        self.contentViews.append(contentView2)
        self.contentViews.append(contentView3)
        
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
        self.outerVisibleView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        self.profileHeaderHeight = self.userProfileHeaderView.frame.height
        
        self.slideMenuBarView.initializeSliderPostion(pos: self.currentPageIndex)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("self.view.frame is ", self.view.frame.debugDescription)
        print("self.outerVisibleView.frame is ", self.outerVisibleView.frame.debugDescription)
        print("self.userProfileHeaderView.frame is ", self.userProfileHeaderView.frame.debugDescription)
        print("self.slideMenuBarView.frame is ", self.slideMenuBarView.frame.debugDescription)
        print("self.contentDisplayView.frame is ", self.contentDisplayView.frame.debugDescription)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FlyHomeToFollowView" {
            let destVC = segue.destination as! FollowerFollowingViewController
            destVC.contentType = self.segueDestContentType
            
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            self.navigationItem.backBarButtonItem = backItem
        }
    }
    
}

extension FlyHomeViewController {
    
    // PanGestureRecognizer function
    func hSwipeGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.contentDisplayView)
        let velocity = gestureRecognizer.velocity(in: self.contentDisplayView)
        
        let displacementX = self.hSwipeStartPoint.x - translation.x
//        let displacementY = translation.y - self.hSwipeStartPoint.y
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            self.hSwipeStartPoint = translation
            self.enableHSwipe = (abs(velocity.x) > abs(velocity.y))
        } else if gestureRecognizer.state == UIGestureRecognizerState.changed {
//            print("Disaplacement: dx=\(displacementX), dy=\(displacementY)")
            if self.enableHSwipe {
                let ratio = displacementX/(self.view.frame.width)
                self.slideMenuBarView.moveSlider(ratio: ratio)
                self.slideContentDisplayView(ratio: ratio)
            }
        } else if gestureRecognizer.state == UIGestureRecognizerState.ended {
            if self.enableHSwipe {
                let totalWidth = self.view.frame.width
                if velocity.x < -250.0 {
                    print("go right to next page, velocity.x = \(velocity.x)")
                    self.continueHorizontalSliding(step: 1)
                } else if velocity.x > 250.0 {
                    print("go left to next page, velocity.x = \(velocity.x)")
                    self.continueHorizontalSliding(step: -1)
                } else {
                    if displacementX < -0.5*totalWidth {
                        print("Continue to go left")
                        self.continueHorizontalSliding(step: -1)
                    } else if displacementX > 0.5*totalWidth {
                        print("Continue to go right")
                        self.continueHorizontalSliding(step: 1)
                    } else {
                        print("Return back to center")
                        self.continueHorizontalSliding(step: 0)
                    }
                }
            }
        }
    }
    
    func vSwipeGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.contentDisplayView)
        let velocity = gestureRecognizer.velocity(in: self.contentDisplayView)
        
//        let displacementX = self.hSwipeStartPoint.x - translation.x
        let displacementY = translation.y - self.hSwipeStartPoint.y
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            self.hSwipeStartPoint = translation
            self.enableVSwipe = (abs(velocity.x) < abs(velocity.y)) && ((velocity.y < 0 && !self.currentHeaderStateIsTop) || (velocity.y > 0 && self.currentHeaderStateIsTop))
        } else if gestureRecognizer.state == UIGestureRecognizerState.changed {
//            print("Disaplacement: dx=\(displacementX), dy=\(displacementY)")
            if self.enableVSwipe {
//                print("self.enableVSwipe is true.")
                if (displacementY <= 0 && displacementY >= -self.profileHeaderHeight && !self.currentHeaderStateIsTop) {
                    self.profileHeaderTopContraint.constant = displacementY
                } else if (displacementY >= 0 && displacementY <= self.profileHeaderHeight && self.currentHeaderStateIsTop) {
                    self.profileHeaderTopContraint.constant = displacementY - self.profileHeaderHeight
                }
            }
        } else if gestureRecognizer.state == UIGestureRecognizerState.ended {
            if self.enableVSwipe {
                if velocity.y < -250.0 {
                    print("go up to top, velocity.y = \(velocity.y)")
                    self.continueVerticalSliding(destinationIsTop: true)
                } else if velocity.y > 250.0 {
                    print("go down to middle, velocity.y = \(velocity.y)")
                    self.continueVerticalSliding(destinationIsTop: false)
                } else {
                    if self.profileHeaderTopContraint.constant < -0.5*self.profileHeaderHeight {
                        print("Continue to go top")
                        self.continueVerticalSliding(destinationIsTop: true)
                    } else {
                        print("Continue to go middle")
                        self.continueVerticalSliding(destinationIsTop: false)
                    }
                }
            }
        }
    }
    
    // rightBarButtonPressed funciton
    func rightBarButtonPressed() {
        print("--- yes! rightBarButtonPressed() func.")
    }
    
    func slideContentDisplayView(ratio: CGFloat) {
        
    }
    
    func contentDisplayViewJumpToIndex(index: Int) {
        self.currentPageIndex = index
        print("contentDisplayView swipe animation done, arrive at \(self.currentPageIndex)")
    }
    
    func continueHorizontalSliding(step: Int) {
        self.currentPageIndex += step
        if self.currentPageIndex == 0 {
            self.currentPageIndex = 1
        } else if self.currentPageIndex == 4 {
            self.currentPageIndex = 3
        }
        self.slideMenuBarView.animateSlidingToPos(pos: self.currentPageIndex)
    }
    
    func continueVerticalSliding(destinationIsTop: Bool) {
        print("continueVerticalSliding(destinationIstop: \(destinationIsTop))")
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            if destinationIsTop {
                self.profileHeaderTopContraint.constant = -self.profileHeaderHeight
            } else {
                self.profileHeaderTopContraint.constant = 0.0
            }
        }, completion: nil)
        self.currentHeaderStateIsTop = destinationIsTop
    }
    
}
