//
//  FindTogetherWithViewController.swift
//  Rattit
//
//  Created by DINGKaile on 7/1/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class FindTogetherWithViewController: UIViewController {
    
    @IBOutlet weak var outScrollView: UIScrollView!
    @IBOutlet weak var topSelectedUsersView: UIView!
    @IBOutlet weak var findTogetherWithTable: UITableView!
    
    @IBOutlet weak var topSelectedUserScrollView: UIScrollView!
    @IBOutlet weak var noSelectedUserLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.findTogetherWithTable.dataSource = self
        self.findTogetherWithTable.delegate = self
        self.findTogetherWithTable.estimatedRowHeight = 44.0
        self.findTogetherWithTable.rowHeight = UITableViewAutomaticDimension
        self.findTogetherWithTable.sectionHeaderHeight = 18.0
        let grayTableHeaderView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 18.0))
        grayTableHeaderView.backgroundColor = UIColor(red: 0.9255, green: 0.9255, blue: 0.9255, alpha: 1.0)
        self.findTogetherWithTable.tableHeaderView = grayTableHeaderView
        
        ComposeContentManager.sharedInstance.updateSelectedUsersDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let totalWidth = self.view.bounds.width
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.height
        self.outScrollView.contentSize = CGSize(width: totalWidth, height: (self.view.bounds.height-navBarHeight!-statusBarHeight))
        
        if ComposeContentManager.sharedInstance.pickedUsersForTogether.isEmpty {
            self.layoutShowNoSelectionLabel()
        } else {
            self.layoutShowSelectedScrollView()
            self.reloadTopSelectedUserScrollView()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("viewDidAppear(), self.topSelectedUsersView.frame = \(self.topSelectedUsersView.frame.debugDescription), self.findTogetherWithTable.frame = \(self.findTogetherWithTable.frame.debugDescription)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension FindTogetherWithViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RattitUserManager.sharedInstance.cachedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindPeopleChoicesTableViewCell") as! FindPeopleChoicesTableViewCell
        let userToShow = Array(RattitUserManager.sharedInstance.cachedUsers.values)[indexPath.row]
        cell.initializeData(user: userToShow)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let userIdSelected = Array(RattitUserManager.sharedInstance.cachedUsers.keys)[indexPath.row]
        if !ComposeContentManager.sharedInstance.pickedUsersForTogether.contains(userIdSelected) {
            if ComposeContentManager.sharedInstance.pickedUsersForTogether.isEmpty {
                UIView.animate(withDuration: 0.2, animations: {
                    
                    self.layoutShowSelectedScrollView()
                }, completion: { (success) in
                    print("animation success: \(success)")
                    
                    ComposeContentManager.sharedInstance.insertNewUserToSelectedGroup(userId: userIdSelected)
                })
            } else {
                ComposeContentManager.sharedInstance.insertNewUserToSelectedGroup(userId: userIdSelected)
            }
        }
        return nil
    }
    
}

extension FindTogetherWithViewController {
    
    func layoutShowNoSelectionLabel() {
        let totalWidth = self.view.bounds.width
        let totalHeight = self.outScrollView.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.height
        self.topSelectedUsersView.frame = CGRect(x: 0.0, y: 0.0, width: totalWidth, height: 37.0)
        self.findTogetherWithTable.frame = CGRect(x: 0.0, y: 37.0, width: totalWidth, height: (totalHeight-37.0-navBarHeight!-statusBarHeight))
        self.topSelectedUserScrollView.isHidden = true
        self.noSelectedUserLabel.isHidden = false
        self.noSelectedUserLabel.frame = CGRect(x: 0.0, y: 8.0, width: totalWidth, height: 21.0)
    }
    
    func layoutShowSelectedScrollView() {
        let totalWidth = self.view.bounds.width
        let totalHeight = self.outScrollView.frame.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = self.navigationController?.navigationBar.frame.height
        self.topSelectedUsersView.frame = CGRect(x: 0.0, y: 0.0, width: totalWidth, height: 88.0)
        self.findTogetherWithTable.frame = CGRect(x: 0.0, y: 88.0, width: totalWidth, height: (totalHeight-88.0-navBarHeight!-statusBarHeight))
        self.noSelectedUserLabel.isHidden = true
        self.topSelectedUserScrollView.isHidden = false
        self.topSelectedUserScrollView.frame = CGRect(x: 8.0, y: 8.0, width: (totalWidth-16.0), height: (totalHeight-16.0))
    }
    
    func reloadTopSelectedUserScrollView() {
        
        let numOfUsers = ComposeContentManager.sharedInstance.pickedUsersForTogether.count
        
        self.topSelectedUserScrollView.contentSize = CGSize(width: 72.0*Double(numOfUsers), height: 72.0)
        
        ComposeContentManager.sharedInstance.uiviewOfPickedUsersForTogether.forEach { (pickedUserView) in
            pickedUserView.removeFromSuperview()
        }
        ComposeContentManager.sharedInstance.uiviewOfPickedUsersForTogether.removeAll()
        ComposeContentManager.sharedInstance.pickedUsersForTogether.enumerated().forEach({ (offset, userId) in
            
            let pickedUserView = PickedUserTogetherWithView.instantiateFromXib()
            self.topSelectedUserScrollView.addSubview(pickedUserView)
            pickedUserView.frame = CGRect(x: 72.0*Double(offset), y: 0.0, width: 72.0, height: 72.0)
            pickedUserView.initializeData(userId: userId)
            ComposeContentManager.sharedInstance.uiviewOfPickedUsersForTogether.append(pickedUserView)
        })
    }
}

extension FindTogetherWithViewController: ComposeContentUpdateSelectedUsersDelegate {
    func updateSelectedGroup() {
        print("updateSelectedGroup() delegate func.")
        
        self.reloadTopSelectedUserScrollView()
        if ComposeContentManager.sharedInstance.pickedUsersForTogether.count == 0 {
            UIView.animate(withDuration: 0.2, animations: {
                self.layoutShowNoSelectionLabel()
            })
        }
    }
}
