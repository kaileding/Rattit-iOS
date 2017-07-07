//
//  FollowerFollowingViewController.swift
//  Rattit
//
//  Created by DINGKaile on 7/6/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class FollowerFollowingViewController: UIViewController {
    
    @IBOutlet weak var contentTableView: UITableView!
    
    
    
    
    var contentType: RattitUserRelationshipType = .follower
    var usersList: [String] = [] // array of userIds
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.contentTableView.dataSource = self
        self.contentTableView.delegate = self
        self.contentTableView.estimatedRowHeight = 62.0
        self.contentTableView.rowHeight = UITableViewAutomaticDimension
        
        let userCellNib = UINib(nibName: "ReusableUserTableViewCell", bundle: nil)
        self.contentTableView.register(userCellNib, forCellReuseIdentifier: "ReusableUserTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch self.contentType {
        case .follower:
            self.navigationItem.title = "My Followers"
        case .followee:
            self.navigationItem.title = "My Followings"
        case .friends:
            self.navigationItem.title = "My Friends"
        }
        
        let selfUser = UserStateManager.sharedInstance.dummyUser
        RattitUserManager.sharedInstance.getFollowersOrFolloweesOfUser(userId: selfUser!.id!, relationType: self.contentType, completion: { (userGroupIds) in
            
            self.usersList = userGroupIds
            self.contentTableView.reloadData()
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

extension FollowerFollowingViewController: UITableViewDataSource, UITableViewDelegate, ReusableUserCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableUserTableViewCell", for: indexPath) as! ReusableUserTableViewCell
        let userId = self.usersList[indexPath.row]
        cell.initializeData(userId: userId, isFollowing: (indexPath.row / 2 == 0), parentVC: self)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func tappedUserAvatarOfCell(userId: String) {
        print("tappedUserAvatarOfCell delegate func called.")
    }
    
    func tappedFollowButtonOfCell(userId: String, toFollow: Bool) {
        print("tappedFollowButtonOfCell delegate func called.")
    }
}
