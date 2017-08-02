//
//  AnswerDetailsViewController.swift
//  Rattit
//
//  Created by DINGKaile on 7/30/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class AnswerDetailsViewController: UIViewController {
    
    @IBOutlet weak var authorAvatarImageView: UIImageView!
    @IBOutlet weak var avatarImageButton: UIButton!
    @IBOutlet weak var authorFullNameLabel: UILabel!
    @IBOutlet weak var authorManifestoLabel: UILabel!
    @IBOutlet weak var followButton: ReusableFollowingButtonView!
    
    @IBOutlet weak var textView: UITextView!
    
    var navBarTitleView: AnswerDetailsVCNavTitleBarView = AnswerDetailsVCNavTitleBarView.instantiateFromXib()
    
    var answerId: String? = nil
    var userId: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.titleView = self.navBarTitleView
        
        self.authorAvatarImageView.layer.cornerRadius = 18.0
        self.authorAvatarImageView.clipsToBounds = true
        self.authorAvatarImageView.contentMode = .scaleAspectFill
        
        self.avatarImageButton.addTarget(self, action: #selector(avatarImageButtonPressed), for: .touchUpInside)
        
        self.textView.isEditable = false
        self.textView.backgroundColor = RattitStyleColors.textBackgroundGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let answerId = self.answerId, let answer = AnswerManager.sharedInstance.downloadedContents[answerId] {
            self.navBarTitleView.initializeData(questionId: answer.forQuestion)
            
            if let createdBy = answer.createdBy {
                self.userId = createdBy
                RattitUserManager.sharedInstance.getRattitUserAvatarImage(userId: createdBy, completion: { (avatarImage) in
                    self.authorAvatarImageView.image = avatarImage
                }, errorHandler: { (error) in
                    print("user has no image")
                    self.authorAvatarImageView.image = UIImage(named: "owlAvatar")
                })
                
                RattitUserManager.sharedInstance.getRattitUserForId(id: createdBy, completion: { (author) in
                    self.authorFullNameLabel.text = author.firstName + " " + author.lastName
                    self.authorManifestoLabel.text = author.manifesto
                }, errorHandler: { (error) in
                    print("user has no username.")
                    self.authorFullNameLabel.text = "alien"
                    self.authorManifestoLabel.text = "-"
                })
                
                let isFollowingThisUser = UserStateManager.sharedInstance.dummyMyFollowees.contains(createdBy)
                self.followButton.initializeData(userId: createdBy, isFollowing: isFollowingThisUser)
            } else {
                self.userId = nil
            }
            
            self.textView.text = answer.words
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

extension AnswerDetailsViewController {
    func avatarImageButtonPressed() {
        if self.userId == UserStateManager.sharedInstance.dummyUserId { // it is selfUser
            self.tabBarController?.selectedIndex = 3
        } else { // it is other user
            let friendProfileVC = ReusableFriendProfileViewController(nibName: "ReusableFriendProfileViewController", bundle: nil)
            
            friendProfileVC.userId = self.userId
            friendProfileVC.topLayoutGuideHeight = self.topLayoutGuide.length
            friendProfileVC.bottomLayoutGuideHeight = self.bottomLayoutGuide.length
            friendProfileVC.screenWidth = self.view.frame.width
            
            self.navigationController?.pushViewController(friendProfileVC, animated: true)
        }
    }
}
