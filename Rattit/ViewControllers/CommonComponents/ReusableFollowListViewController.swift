//
//  ReusableFollowListViewController.swift
//  Rattit
//
//  Created by DINGKaile on 7/25/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ReusableFollowListViewController: UIViewController {
    
    @IBOutlet weak var followTable: UITableView!
    
    
    var ownerId: String!
    var contentType: RattitUserRelationshipType = .follower
    var navigationTitle: String!
    var usersList: [String] = [] // array of userIds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.followTable.dataSource = self
        self.followTable.delegate = self
        self.followTable.estimatedRowHeight = 62.0
        self.followTable.rowHeight = UITableViewAutomaticDimension
        
        let userCellNib = UINib(nibName: "ReusableUserTableViewCell", bundle: nil)
        self.followTable.register(userCellNib, forCellReuseIdentifier: "ReusableUserTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = self.navigationTitle
        RattitUserManager.sharedInstance.getFollowersOrFolloweesOfUser(userId: self.ownerId, relationType: self.contentType, completion: { (totalNum, userGroupIds) in
            
            self.usersList = userGroupIds
            self.followTable.reloadData()
        }) { (error) in
            print("Unable to get \(self.contentType.rawValue) from RattitUserManager.")
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

extension ReusableFollowListViewController: UITableViewDataSource, UITableViewDelegate, ReusableUserCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableUserTableViewCell", for: indexPath) as! ReusableUserTableViewCell
        let userId = self.usersList[indexPath.row]
        cell.initializeData(userId: userId, parentVC: self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tappedUserAvatarOfCell(userId: String) {
        print("in FollowerFollowingViewController, tappedUserAvatarOfCell() func called.")
        let friendProfileVC = ReusableFriendProfileViewController(nibName: "ReusableFriendProfileViewController", bundle: nil)
        
        friendProfileVC.userId = userId
        friendProfileVC.topLayoutGuideHeight = self.topLayoutGuide.length
        friendProfileVC.bottomLayoutGuideHeight = self.bottomLayoutGuide.length
        friendProfileVC.screenWidth = self.view.frame.width
        
        self.navigationItem.title = "Back"
        self.navigationController?.pushViewController(friendProfileVC, animated: true)
    }
}
