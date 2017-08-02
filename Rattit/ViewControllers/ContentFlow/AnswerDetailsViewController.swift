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
    @IBOutlet weak var authorFullNameLabel: UILabel!
    @IBOutlet weak var authorManifestoLabel: UILabel!
    @IBOutlet weak var followButton: ReusableFollowingButtonView!
    
    
    var answerId: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.authorAvatarImageView.layer.cornerRadius = 18.0
        self.authorAvatarImageView.clipsToBounds = true
        self.authorAvatarImageView.contentMode = .scaleAspectFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let answerId = self.answerId, let answer = AnswerManager.sharedInstance.downloadedContents[answerId] {
            if let createdBy = answer.createdBy {
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
            }
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
