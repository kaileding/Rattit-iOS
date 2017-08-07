//
//  MomentDetailsViewController.swift
//  Rattit
//
//  Created by DINGKaile on 7/30/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class MomentDetailsViewController: UIViewController {
    
    @IBOutlet weak var dataTableView: UITableView!
    
    let textInputBar = ReusableGrowingTextInputBar()
    let keyboardObserver = ReusableKeyboardObservingView()
    
    var momentId: String? = nil
    
    override var inputAccessoryView: UIView? {
        get {
            return self.keyboardObserver
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataTableView.dataSource = self
        self.dataTableView.delegate = self
        let momentDetailsCellNib = UINib(nibName: "MomentDetailsTableViewCell", bundle: nil)
        self.dataTableView.register(momentDetailsCellNib, forCellReuseIdentifier: "MomentDetailsTableViewCell")
        let momentCommentCellNib = UINib(nibName: "MomentCommentTableViewCell", bundle: nil)
        self.dataTableView.register(momentCommentCellNib, forCellReuseIdentifier: "MomentCommentTableViewCell")
        let momentCommentReplyCellNib = UINib(nibName: "MomentCommentReplyTableViewCell", bundle: nil)
        self.dataTableView.register(momentCommentReplyCellNib, forCellReuseIdentifier: "MomentCommentReplyTableViewCell")
        self.dataTableView.rowHeight = UITableViewAutomaticDimension
        self.dataTableView.estimatedRowHeight = 65.0
        
        self.keyboardObserver.isUserInteractionEnabled = false
        self.textInputBar.keyboardObserver = self.keyboardObserver
        self.view.addSubview(self.textInputBar)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChanged(notification:)), name: NSNotification.Name(rawValue: ContentOperationNotificationName.keyboardFrameDidChange.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.textInputBar.frame = CGRect(x: 0, y: view.frame.size.height - textInputBar.defaultHeight, width: view.frame.size.width, height: textInputBar.defaultHeight)
        
        self.dataTableView.reloadData()
        if self.momentId != nil {
            MomentCommentManager.sharedInstance.loadCommentsOfAMomentFromServer(momentId: self.momentId!, completion: {
                
                self.dataTableView.reloadData()
            }, errorHandler: { (error) in
                print("MomentCommentManager.loadCommentsOfAMomentFromServer() failed.")
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MomentDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if momentId == nil {
            return 0
        } else {
            return 1 + MomentCommentManager.sharedInstance.dialogDisplaySequence.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MomentDetailsTableViewCell", for: indexPath) as! MomentDetailsTableViewCell
            
            let moment = MomentManager.sharedInstance.downloadedContents[self.momentId!]
            cell.initializeData(moment: moment!)
            
            return cell
        } else {
            let momentCommentId = MomentCommentManager.sharedInstance.dialogDisplaySequence[indexPath.row-1]
            let momentComment = MomentCommentManager.sharedInstance.downloadedContents[momentCommentId]
            if momentComment!.forComment == nil {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MomentCommentTableViewCell", for: indexPath) as! MomentCommentTableViewCell
                
                cell.initializeData(momentComment: momentComment!, commentFlowDelegate: self)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MomentCommentReplyTableViewCell", for: indexPath) as! MomentCommentReplyTableViewCell
                
                cell.initializeData(momentComment: momentComment!, commentFlowDelegate: self)
                return cell
            }
        }
    }
}

extension MomentDetailsViewController: CommentFlowDelegate {
    func tappedUserAvatarOfCell(userId: String) {
        print("in MomentDetailsViewController, tappedUserAvatarOfCell() func called.")
        
        if userId == UserStateManager.sharedInstance.dummyUserId { // it is selfUser
            self.tabBarController?.selectedIndex = 3
        } else { // it is other user
            let friendProfileVC = ReusableFriendProfileViewController(nibName: "ReusableFriendProfileViewController", bundle: nil)
            
            friendProfileVC.userId = userId
            friendProfileVC.topLayoutGuideHeight = self.topLayoutGuide.length
            friendProfileVC.bottomLayoutGuideHeight = 0
//                self.bottomLayoutGuide.length
            friendProfileVC.screenWidth = self.view.frame.width
            
            self.navigationController?.pushViewController(friendProfileVC, animated: true)
        }
    }
    
    func anImageOfCellIsTapped(infoToShowImageModal: ObjectForShowImagesModal) {
        let imagesModalVC = ReusableImageModalViewController(nibName: "ReusableImageModalViewController", bundle: nil)
        imagesModalVC.photos = infoToShowImageModal.photos
        imagesModalVC.startIndex = min(infoToShowImageModal.startIndex, infoToShowImageModal.photos.count)
        imagesModalVC.screenWidth = self.view.frame.width
        imagesModalVC.screenHeight = self.view.frame.height
        self.present(imagesModalVC, animated: false, completion: nil)
    }
    
}

extension MomentDetailsViewController {
    func keyboardFrameChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            self.textInputBar.frame.origin.y = frame.origin.y
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            self.textInputBar.frame.origin.y = frame.origin.y
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
            self.textInputBar.frame.origin.y = frame.origin.y
        }
    }
}

