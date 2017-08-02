//
//  HomeContentViewController.swift
//  Rattit
//
//  Created by DINGKaile on 6/17/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class HomeContentViewController: UIViewController {
    
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var mainContentTable: UITableView!
    
    let contentFlowNavItemTitleView = Bundle.main.loadNibNamed("ContentFlowNavigationTitleView", owner: self, options: nil)?.first as! UIView
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let contentFlowLeftNavBarItemView = ReusableNavBarItemView.instantiateFromXib(buttonImageName: "camera")
        contentFlowLeftNavBarItemView.setButtonExecutionBlock {
            self.leftBarButtonPressed()
        }
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: contentFlowLeftNavBarItemView)
        
        let contentFlowRightNavBarItemView = ReusableNavBarItemView.instantiateFromXib(buttonImageName: "pencil")
        contentFlowRightNavBarItemView.setButtonExecutionBlock {
            self.rightBarButtonPressed()
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contentFlowRightNavBarItemView)
        
        
        self.mainContentTable.dataSource = self
        self.mainContentTable.delegate = self
        let momentCellNib = UINib(nibName: "MomentTableViewCell", bundle: nil)
        self.mainContentTable.register(momentCellNib, forCellReuseIdentifier: "MomentTableViewCell")
        let questionCellNib = UINib(nibName: "QuestionTableViewCell", bundle: nil)
        self.mainContentTable.register(questionCellNib, forCellReuseIdentifier: "QuestionTableViewCell")
        let answerCellNib = UINib(nibName: "AnswerTableViewCell", bundle: nil)
        self.mainContentTable.register(answerCellNib, forCellReuseIdentifier: "AnswerTableViewCell")
        self.mainContentTable.rowHeight = UITableViewAutomaticDimension
        self.mainContentTable.estimatedRowHeight = 65.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.titleView = self.contentFlowNavItemTitleView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppInfoManager.navBarHeight = self.navigationController!.navigationBar.frame.height
        
        if !UserStateManager.initialContentLoaded {
            DataFlowManager.sharedInstance.loadUnitsFromServer(completion: {
                
                print("HomeContentViewController.viewDidAppear(), load from server success.")
                UserStateManager.initialContentLoaded = true
                self.mainContentTable.reloadData()
                
            }, errorHandler: { (error) in
                print("HomeContentViewController.viewDidAppear(), failed to load from server.")
            })
        }
        
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

extension HomeContentViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataFlowManager.sharedInstance.allContentUnits.count
//        return MomentManager.sharedInstance.displaySequenceOfContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sideLength = Double(self.view.frame.width)
        let dataUnit = DataFlowManager.sharedInstance.allContentUnits[indexPath.row]
        switch dataUnit.contentType {
        case .moment:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MomentTableViewCell", for: indexPath) as! MomentTableViewCell
            let moment = MomentManager.sharedInstance.downloadedContents[dataUnit.id]!
            cell.initializeContent(moment: moment, sideLength: sideLength, contentDelegate: self)
            return cell
        case .question:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
            let question = QuestionManager.sharedInstance.downloadedContents[dataUnit.id]!
            cell.initializeContent(question: question, sideLength: sideLength, flowDelegate: self)
            return cell
        case .answer:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell", for: indexPath) as! AnswerTableViewCell
            let answer = AnswerManager.sharedInstance.downloadedContents[dataUnit.id]!
            cell.initializeContent(answer: answer, sideLength: sideLength, flowDelegate: self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.mainContentTable.deselectRow(at: indexPath, animated: false)
        print("tableView willSelectRowAt ", indexPath.debugDescription)
        return nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!UserStateManager.userIsLoggedIn && !UserStateManager.userRefusedToLogin && !UserStateManager.showingSignInAlert) {
            NotificationCenter.default.post(name: NSNotification.Name(SignInSignUpNotificationName.needsToSignInOrSignUp.rawValue), object: nil)
            print("Sent out needsToSignInOrSignUp notification.")
        }
    }
    
}

extension HomeContentViewController: ContentFlowDelegate {
    func tappedUserAvatarOfCell(userId: String) {
        print("in HomeContentViewController, tappedUserAvatarOfCell() func called.")
        
        if userId == UserStateManager.sharedInstance.dummyUserId { // it is selfUser
            self.tabBarController?.selectedIndex = 3
        } else { // it is other user
            let friendProfileVC = ReusableFriendProfileViewController(nibName: "ReusableFriendProfileViewController", bundle: nil)
            
            friendProfileVC.userId = userId
            friendProfileVC.topLayoutGuideHeight = self.topLayoutGuide.length
            friendProfileVC.bottomLayoutGuideHeight = self.bottomLayoutGuide.length
            friendProfileVC.screenWidth = self.view.frame.width
            
            self.navigationController?.pushViewController(friendProfileVC, animated: true)
        }
    }
    
    func aContentCellIsSelected(contentId: String, contentType: RattitContentType) {
        print("aContentCellIsSelected() func.")
        if contentType == .moment {
            let contentFlowSB: UIStoryboard = UIStoryboard(name: "ContentFlow", bundle: nil)
            let momentDetailsVC = contentFlowSB.instantiateViewController(withIdentifier: "MomentDetailsViewController") as! MomentDetailsViewController
            momentDetailsVC.momentId = contentId
            self.navigationItem.title = ""
            self.navigationController?.pushViewController(momentDetailsVC, animated: true)
        } else if contentType == .question {
            let contentFlowSB: UIStoryboard = UIStoryboard(name: "ContentFlow", bundle: nil)
            let questionDetailsVC = contentFlowSB.instantiateViewController(withIdentifier: "QuestionDetailsViewController") as! QuestionDetailsViewController
            questionDetailsVC.questionId = contentId
            self.navigationItem.title = ""
            self.navigationController?.pushViewController(questionDetailsVC, animated: true)
        } else if contentType == .answer {
            let contentFlowSB: UIStoryboard = UIStoryboard(name: "ContentFlow", bundle: nil)
            let answerDetailsVC = contentFlowSB.instantiateViewController(withIdentifier: "AnswerDetailsViewController") as! AnswerDetailsViewController
            answerDetailsVC.answerId = contentId
            self.navigationItem.title = ""
            self.navigationController?.pushViewController(answerDetailsVC, animated: true)
        }
    }
}

extension HomeContentViewController {
    func leftBarButtonPressed() {
        print("--- yes! leftBarButtonPressed() func called.")
        
        if (!UserStateManager.userIsLoggedIn && !UserStateManager.userRefusedToLogin && !UserStateManager.showingSignInAlert) {
            NotificationCenter.default.post(name: NSNotification.Name(SignInSignUpNotificationName.needsToSignInOrSignUp.rawValue), object: nil)
            print("Sent out needsToSignInOrSignUp notification.")
        } else if UserStateManager.userIsLoggedIn || UserStateManager.userRefusedToLogin {
            NotificationCenter.default.post(name: NSNotification.Name(ContentOperationNotificationName.composeMoment.rawValue), object: nil, userInfo: nil)
        }
    }
    
    func rightBarButtonPressed() {
        print("--- yes! rightBarButtonPressed() func called.")
        
        if (!UserStateManager.userIsLoggedIn && !UserStateManager.userRefusedToLogin && !UserStateManager.showingSignInAlert) {
            NotificationCenter.default.post(name: NSNotification.Name(SignInSignUpNotificationName.needsToSignInOrSignUp.rawValue), object: nil)
            print("Sent out needsToSignInOrSignUp notification.")
        } else if UserStateManager.userIsLoggedIn || UserStateManager.userRefusedToLogin {
            NotificationCenter.default.post(name: NSNotification.Name(ContentOperationNotificationName.composeQuestion.rawValue), object: nil, userInfo: nil)
        }
    }
}
