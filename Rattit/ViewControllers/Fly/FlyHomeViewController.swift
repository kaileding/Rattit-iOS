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
    @IBOutlet weak var userProfileHeaderView: UserProfileHeaderView!
    @IBOutlet weak var slidingTabMenuBarView: SlidingTabMenuBarView!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    
//    @IBOutlet weak var contentCollectionView: UICollectionView!
    
    let contentScrollViewTag: Int = 100
    let contentTableView1Tag: Int = 101
    let contentTableView2Tag: Int = 102
    let contentTableView3Tag: Int = 103
    
    var contentViewBGColors: [UIColor] = []
    @IBOutlet weak var contentScrollCanvasView: UIView!
    var contentTableView1: ContentDisplayTableView = ContentDisplayTableView.instantiateFromXib()
    var contentTableView2: ContentDisplayTableView = ContentDisplayTableView.instantiateFromXib()
    var contentTableView3: ContentDisplayTableView = ContentDisplayTableView.instantiateFromXib()
    
    // horizontal swipe
    var currentPageIndex: Int = 1 // 1, 2 or 3
    var stableContentOffset: CGFloat = 0.0
    var notDriveSliderByCollectionView: Bool = false
    
    // vertical swipe
    @IBOutlet weak var profileHeaderTopConstraint: NSLayoutConstraint!
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
        
        self.slidingTabMenuBarView.setTabMenuTappingHandler { (destinationIndex) in
            self.contentDisplayViewJumpToIndex(index: destinationIndex)
        }
        
        self.contentScrollView.delegate = self
        self.contentScrollView.tag = contentScrollViewTag
        self.contentScrollCanvasView.addSubview(self.contentTableView1)
        self.contentScrollCanvasView.addSubview(self.contentTableView2)
        self.contentScrollCanvasView.addSubview(self.contentTableView3)
        
        let tablesHSpacing = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[t1(==t2)]-0-[t2]-0-[t3(==t2)]-0-|", options: .alignAllCenterY, metrics: nil, views: ["t1": self.contentTableView1, "t2": self.contentTableView2, "t3": self.contentTableView3])
        let tablesVSpacing1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[t1]-0-|", metrics: nil, views: ["t1": self.contentTableView1])
        let tablesVSpacing2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[t2]-0-|", metrics: nil, views: ["t2": self.contentTableView2])
        let tablesVSpacing3 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[t3]-0-|", metrics: nil, views: ["t3": self.contentTableView3])
        NSLayoutConstraint.activate(tablesHSpacing)
        NSLayoutConstraint.activate(tablesVSpacing1)
        NSLayoutConstraint.activate(tablesVSpacing2)
        NSLayoutConstraint.activate(tablesVSpacing3)
        
        self.contentViewBGColors.append(UIColor(red: 0.2235, green: 0.5882, blue: 0, alpha: 1.0))
        self.contentViewBGColors.append(UIColor(red: 0, green: 0.6, blue: 0.5373, alpha: 1.0))
        self.contentViewBGColors.append(UIColor(red: 0.5569, green: 0, blue: 0.5412, alpha: 1.0))
        
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
        
        self.slidingTabMenuBarView.initializeSliderPostion(pos: self.currentPageIndex)
        
        self.contentTableView1.initializeData(backgroundColor: UIColor(red: 0.2235, green: 0.5882, blue: 0, alpha: 1.0))
        self.contentTableView2.initializeData(backgroundColor: UIColor(red: 0, green: 0.6, blue: 0.5373, alpha: 1.0))
        self.contentTableView3.initializeData(backgroundColor: UIColor(red: 0.5569, green: 0, blue: 0.5412, alpha: 1.0))
        self.contentScrollView.layoutIfNeeded()
        
        print("\n in viewWillAppear:")
        print("self.contentTableView1.frame is ", self.contentTableView1.frame.debugDescription)
        print("self.contentTableView2.frame is ", self.contentTableView2.frame.debugDescription)
        print("self.contentTableView3.frame is ", self.contentTableView3.frame.debugDescription)
        print("self.contentScrollView.frame is ", self.contentScrollView.frame.debugDescription, "self.contentScrollView.contentSize is ", self.contentScrollView.contentSize.debugDescription)
        print("self.contentScrollCanvasView.frame is ", self.contentScrollCanvasView.frame.debugDescription)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("\n in ViewDidAppear:")
        print("self.view.frame is ", self.view.frame.debugDescription)
        print("self.outerVisibleView.frame is ", self.outerVisibleView.frame.debugDescription)
//        print("self.userProfileHeaderView.frame is ", self.userProfileHeaderView.frame.debugDescription)
//        print("self.slideMenuBarView.frame is ", self.slidingTabMenuBarView.frame.debugDescription)
        
        print("self.currentPageIndex is ", self.currentPageIndex)
        
        print("self.contentTableView1.frame is ", self.contentTableView1.frame.debugDescription)
        print("self.contentTableView2.frame is ", self.contentTableView2.frame.debugDescription)
        print("self.contentTableView3.frame is ", self.contentTableView3.frame.debugDescription)
        print("self.contentScrollView.frame is ", self.contentScrollView.frame.debugDescription, "self.contentScrollView.contentSize is ", self.contentScrollView.contentSize.debugDescription)
        print("self.contentScrollCanvasView.frame is ", self.contentScrollCanvasView.frame.debugDescription)
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

extension FlyHomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == contentScrollViewTag && !self.notDriveSliderByCollectionView { // check it is contentScrollViewTag
            let offsetVal = scrollView.contentOffset.x
            let displacementX = offsetVal - self.stableContentOffset
            let ratio = displacementX/(self.contentScrollView.frame.width)
            self.slidingTabMenuBarView.moveSlider(ratio: ratio)
//            print("offsetVal is : \(offsetVal)")
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == contentScrollViewTag { // check it is contentScrollViewTag
            self.stableContentOffset = scrollView.contentOffset.x
            let screenWidth = self.contentScrollView.frame.width
            self.currentPageIndex = Int(floor(self.stableContentOffset / screenWidth)) + 1
            self.slidingTabMenuBarView.animateSlidingToPos(pos: self.currentPageIndex)
            
            print("scrollViewDidEndDecelerating: self.stableContentOffset is \(self.stableContentOffset), self.currentPageIndex is \(self.currentPageIndex)")
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView.tag == contentScrollViewTag { // check it is contentScrollViewTag
            self.stableContentOffset = scrollView.contentOffset.x
            let screenWidth = self.contentScrollView.frame.width
            self.currentPageIndex = Int(floor(self.stableContentOffset / screenWidth)) + 1
            self.notDriveSliderByCollectionView = false
            
            print("scrollViewDidEndScrollingAnimation: self.stableContentOffset is \(self.stableContentOffset), self.currentPageIndex is \(self.currentPageIndex)")
        }
    }
    
}

extension FlyHomeViewController {
    
    // rightBarButtonPressed funciton
    func rightBarButtonPressed() {
        print("--- yes! rightBarButtonPressed() func.")
    }
    
    func contentDisplayViewJumpToIndex(index: Int) {
        self.currentPageIndex = index
        self.notDriveSliderByCollectionView = true
        let screenWidth = self.view.frame.width
        let tagetRect = CGRect(x: CGFloat(index-1)*screenWidth, y: 0.0, width: screenWidth, height: self.contentScrollView.frame.height)
        self.contentScrollView.scrollRectToVisible(tagetRect, animated: true)
        print("contentDisplayView swipe animation done, arrive at \(self.currentPageIndex)")
    }
    
    func continueVerticalSliding(destinationIsTop: Bool) {
        print("continueVerticalSliding(destinationIstop: \(destinationIsTop))")
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
            if destinationIsTop {
                self.profileHeaderTopConstraint.constant = -self.profileHeaderHeight
            } else {
                self.profileHeaderTopConstraint.constant = 0.0
            }
        }, completion: nil)
        self.currentHeaderStateIsTop = destinationIsTop
    }
    
}
