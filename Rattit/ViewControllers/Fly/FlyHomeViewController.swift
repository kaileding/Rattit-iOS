//
//  FlyHomeViewController.swift
//  Rattit
//
//  Created by DINGKaile on 7/4/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class FlyHomeViewController: UIViewController, UIGestureRecognizerDelegate, SlideTableHeaderDelegate {
    
    @IBOutlet weak var outerVisibleView: UIView!
    @IBOutlet weak var userProfileHeaderView: UserProfileHeaderView!
    @IBOutlet weak var slidingTabMenuBarView: SlidingTabMenuBarView!
    @IBOutlet weak var contentCanvasView: UIView!
    
    var flyHomeViewNavBarTitleView: FlyHomeViewNavBarTitleView = FlyHomeViewNavBarTitleView.instantiateFromXib()
    
    var contentTableView1: ContentDisplayTableView = ContentDisplayTableView.instantiateFromXib()
    var contentTableView2: ContentDisplayTableView = ContentDisplayTableView.instantiateFromXib()
    var contentTableView3: ContentDisplayTableView = ContentDisplayTableView.instantiateFromXib()
    
    // horizontal swipe
    var hSwipeStartPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var enableHSwipe: Bool = false // true if initial abs(velocity.x) > abs(velocity.y)
    var currentPageIndex: Int = 1 // 1, 2 or 3
    var firstContentViewLeadingConstraint: NSLayoutConstraint!
    var firstContentViewLeadingConstraintStartConstant: CGFloat = 0.0
    
    // vertical swipe
    @IBOutlet weak var profileHeaderTopConstraint: NSLayoutConstraint!
    var profileHeaderHeight: CGFloat = 0.0
    
    var segueDestContentType: RattitUserRelationshipType = .follower
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = self.flyHomeViewNavBarTitleView
        let flyHomePageRightBarButtonItemView = ReusableNavBarItemView.instantiateFromXib(buttonImageName: "settingIcon")
        flyHomePageRightBarButtonItemView.setButtonExecutionBlock {
            self.rightBarButtonPressed()
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: flyHomePageRightBarButtonItemView)
        
        self.userProfileHeaderView.setHandlerForFollowerViewTapping {
            self.navigateToFollowListViewController(listContentTye: .follower)
        }
        self.userProfileHeaderView.setHandlerForFollowingViewTapping {
            self.navigateToFollowListViewController(listContentTye: .followee)
        }
        self.userProfileHeaderView.setHandlerForFriendsViewTapping {
            self.navigateToFollowListViewController(listContentTye: .friends)
        }
        
        self.slidingTabMenuBarView.setTabMenuTappingHandler { (destinationIndex) in
            self.contentDisplayViewJumpToIndex(index: destinationIndex)
        }
        let hSwipeRecognizer = UIPanGestureRecognizer(target: self, action: #selector(hSwipeGestureRecognized(gestureRecognizer:)))
        hSwipeRecognizer.delegate = self
        self.contentCanvasView.addGestureRecognizer(hSwipeRecognizer)
        self.contentCanvasView.translatesAutoresizingMaskIntoConstraints = false
        self.setConstraintsToContentViews()
        
        self.contentTableView1.parentVC = self
        self.contentTableView2.parentVC = self
        self.contentTableView3.parentVC = self
        self.contentTableView1.flowDelegate = self
        self.contentTableView2.flowDelegate = self
        self.contentTableView3.flowDelegate = self
        
        self.currentPageIndex = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let selfUser = UserStateManager.sharedInstance.dummyUser
        if let validUser = selfUser {
            self.flyHomeViewNavBarTitleView.initializeData(userName: "@"+validUser.userName, firstName: validUser.firstName)
        } else {
            self.flyHomeViewNavBarTitleView.initializeData(userName: "Rattit", firstName: "Rattit")
        }
        
        let selfUserId = UserStateManager.sharedInstance.dummyUserId
        self.userProfileHeaderView.initializeData(userId: selfUserId)
        self.userProfileHeaderView.sizeToFit()
        self.outerVisibleView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        self.profileHeaderHeight = self.userProfileHeaderView.frame.height
        
        self.slidingTabMenuBarView.initializeSliderPostion(pos: self.currentPageIndex)
        
        let screenWidth = self.view.frame.width
        self.contentTableView1.initializeData(userId: selfUserId, contentType: .moment, sideLength: screenWidth)
        self.contentTableView2.initializeData(userId: selfUserId, contentType: .question, sideLength: screenWidth)
        self.contentTableView3.initializeData(userId: selfUserId, contentType: .answer, sideLength: screenWidth)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        print("\n in ViewDidAppear:")
//        print("self.view.frame is ", self.view.frame.debugDescription)
//        print("self.outerVisibleView.frame is ", self.outerVisibleView.frame.debugDescription)
//        print("self.userProfileHeaderView.frame is ", self.userProfileHeaderView.frame.debugDescription)
//        print("self.slideMenuBarView.frame is ", self.slidingTabMenuBarView.frame.debugDescription)
//
//        print("self.currentPageIndex is ", self.currentPageIndex)
//
//        print("self.contentTableView1.frame is ", self.contentTableView1.frame.debugDescription)
//        print("self.contentTableView2.frame is ", self.contentTableView2.frame.debugDescription)
//        print("self.contentTableView3.frame is ", self.contentTableView3.frame.debugDescription)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension FlyHomeViewController: ContentFlowDelegate {
    func tappedUserAvatarOfCell(userId: String) {
        print("FlyHomeViewController.tappedUserAvatarOfCell() func. Do nothing.")
    }
    
    func aContentCellIsSelected(contentId: String, contentType: RattitContentType) {
        if contentType == .moment {
            let contentFlowSB: UIStoryboard = UIStoryboard(name: "ContentFlow", bundle: nil)
            let momentDetailsVC = contentFlowSB.instantiateViewController(withIdentifier: "MomentDetailsViewController") as! MomentDetailsViewController
            momentDetailsVC.momentId = contentId
            self.navigationController?.pushViewController(momentDetailsVC, animated: true)
        } else if contentType == .question {
            let contentFlowSB: UIStoryboard = UIStoryboard(name: "ContentFlow", bundle: nil)
            let questionDetailsVC = contentFlowSB.instantiateViewController(withIdentifier: "QuestionDetailsViewController") as! QuestionDetailsViewController
            questionDetailsVC.questionId = contentId
            self.navigationController?.pushViewController(questionDetailsVC, animated: true)
        }
    }
}

extension FlyHomeViewController {
    
    // rightBarButtonPressed funciton
    func rightBarButtonPressed() {
        print("--- yes! rightBarButtonPressed() func.")
    }
    
    func navigateToFollowListViewController(listContentTye: RattitUserRelationshipType = .follower) {
        
        let selfUser = UserStateManager.sharedInstance.dummyUser
        if let validUser = selfUser {
            let followListVC = ReusableFollowListViewController(nibName: "ReusableFollowListViewController", bundle: nil)
            followListVC.contentType = listContentTye
            followListVC.ownerId = validUser.id!
            switch listContentTye {
            case .follower:
                followListVC.navigationTitle = "My Followers"
            case .followee:
                followListVC.navigationTitle = "My Followings"
            case .friends:
                followListVC.navigationTitle = "My Friends"
            }
            
            self.navigationController?.pushViewController(followListVC, animated: true)
        }
    }
    
    // PanGestureRecognizer function
    func hSwipeGestureRecognized(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.contentCanvasView)
        let velocity = gestureRecognizer.velocity(in: self.contentCanvasView)
        
        let displacementX = self.hSwipeStartPoint.x - translation.x
        //        let displacementY = translation.y - self.hSwipeStartPoint.y
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            self.hSwipeStartPoint = translation
            self.enableHSwipe = (abs(velocity.x) > abs(velocity.y))
        } else if gestureRecognizer.state == UIGestureRecognizerState.changed {
            //            print("Disaplacement: dx=\(displacementX), dy=\(displacementY)")
            if self.enableHSwipe {
                let ratio = displacementX/(self.view.frame.width)
                self.slidingTabMenuBarView.moveSlider(ratio: ratio)
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
    
    func slideContentDisplayView(ratio: CGFloat) {
        let absDistance = ratio*(self.view.frame.width)
        let targetConstantVal = self.firstContentViewLeadingConstraintStartConstant - absDistance
        if targetConstantVal < 0 && targetConstantVal > -2.0*(self.view.frame.width) {
            self.firstContentViewLeadingConstraint.constant = targetConstantVal
        }
    }
    
    func continueHorizontalSliding(step: Int) {
        self.currentPageIndex += step
        if self.currentPageIndex == 0 {
            self.currentPageIndex = 1
        } else if self.currentPageIndex == 4 {
            self.currentPageIndex = 3
        }
        self.slidingTabMenuBarView.animateSlidingToPos(pos: self.currentPageIndex)
        self.contentDisplayViewJumpToIndex(index: self.currentPageIndex)
    }
    
    func contentDisplayViewJumpToIndex(index: Int) {
        self.currentPageIndex = index
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            switch self.currentPageIndex {
            case 1:
                self.firstContentViewLeadingConstraint.constant = 0.0
            case 2:
                self.firstContentViewLeadingConstraint.constant = -self.view.frame.width
            case 3:
                self.firstContentViewLeadingConstraint.constant = -2.0*self.view.frame.width
            default:
                break
            }
            self.contentCanvasView.layoutIfNeeded()
        }, completion: { (success) in
            self.firstContentViewLeadingConstraintStartConstant = self.firstContentViewLeadingConstraint.constant
            print("contentView continueHorizontalSliding animation complete success: \(success). Arrive at \(self.currentPageIndex)")
        })
    }
    
    func resizeTableHeaderViewHeight(step: CGFloat) {
        let targetConstantVal = self.profileHeaderTopConstraint.constant - step
        let targetRatio = targetConstantVal / (self.profileHeaderHeight)
        //        print("targetConstantVal = \(targetConstantVal)")
        if targetConstantVal < -self.profileHeaderHeight {
            self.profileHeaderTopConstraint.constant = -self.profileHeaderHeight
            self.flyHomeViewNavBarTitleView.slideTitleViews(ratio: -1)
        } else if targetConstantVal > 0 {
            self.profileHeaderTopConstraint.constant = 0
            self.flyHomeViewNavBarTitleView.slideTitleViews(ratio: 0)
        } else {
            self.profileHeaderTopConstraint.constant = targetConstantVal
            self.flyHomeViewNavBarTitleView.slideTitleViews(ratio: targetRatio)
        }
    }
    
    func continueVerticalSliding() {
        self.flyHomeViewNavBarTitleView.continueVerticalSliding()
        
        if self.profileHeaderTopConstraint.constant < -0.5*self.profileHeaderHeight
            && self.profileHeaderTopConstraint.constant > -self.profileHeaderHeight {
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState, animations: {
                
                self.profileHeaderTopConstraint.constant = -self.profileHeaderHeight
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else if self.profileHeaderTopConstraint.constant >= -0.5*self.profileHeaderHeight
            && self.profileHeaderTopConstraint.constant < 0 {
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState, animations: {
                
                self.profileHeaderTopConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func setConstraintsToContentViews() {
        self.contentTableView1.removeFromSuperview()
        self.contentTableView2.removeFromSuperview()
        self.contentTableView3.removeFromSuperview()
        self.contentTableView1.translatesAutoresizingMaskIntoConstraints = false
        self.contentTableView2.translatesAutoresizingMaskIntoConstraints = false
        self.contentTableView3.translatesAutoresizingMaskIntoConstraints = false
        self.contentCanvasView.addSubview(self.contentTableView1)
        self.contentCanvasView.addSubview(self.contentTableView2)
        self.contentCanvasView.addSubview(self.contentTableView3)
        
        let tablesHSpacing = NSLayoutConstraint.constraints(withVisualFormat: "H:[t1(==t2)]-0-[t2]-0-[t3(==t2)]", options: .alignAllCenterY, metrics: nil, views: ["t1": self.contentTableView1, "t2": self.contentTableView2, "t3": self.contentTableView3])
        let tablesVSpacing1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[t1]-0-|", metrics: nil, views: ["t1": self.contentTableView1])
        let tablesVSpacing2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[t2]-0-|", metrics: nil, views: ["t2": self.contentTableView2])
        let tablesVSpacing3 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[t3]-0-|", metrics: nil, views: ["t3": self.contentTableView3])
        NSLayoutConstraint.activate(tablesHSpacing)
        NSLayoutConstraint.activate(tablesVSpacing1)
        NSLayoutConstraint.activate(tablesVSpacing2)
        NSLayoutConstraint.activate(tablesVSpacing3)
        self.contentTableView1.widthAnchor.constraint(equalTo: self.contentCanvasView.widthAnchor, constant: 0.0).isActive = true
        
        self.firstContentViewLeadingConstraint = self.contentTableView1.leadingAnchor.constraint(equalTo: self.contentCanvasView.leadingAnchor, constant: 0.0)
        self.firstContentViewLeadingConstraintStartConstant = 0.0
        self.firstContentViewLeadingConstraint.isActive = true
    }
    
}
