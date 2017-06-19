//
//  DummyHomeViewController.swift
//  Rattit
//
//  Created by DINGKaile on 6/17/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class DummyHomeViewController: UIViewController {
    
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var mainContentTable: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let contentFlowNavItemTitleView = Bundle.main.loadNibNamed("ContentFlowNavigationTitleView", owner: self, options: nil)?.first as! UIView
        self.navigationItem.titleView = contentFlowNavItemTitleView
        
        self.mainContentTable.dataSource = self
        self.mainContentTable.delegate = self
        let momentCellNib = UINib(nibName: "MomentTableViewCell", bundle: nil)
        self.mainContentTable.register(momentCellNib, forCellReuseIdentifier: "MomentTableViewCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.mainContentTable.rowHeight = UITableViewAutomaticDimension
        self.mainContentTable.estimatedRowHeight = 65.0
        
        MomentManager.getLatestMoments {
            self.mainContentTable.reloadData()
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

extension DummyHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MomentManager.downloadedMoments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentTableViewCell", for: indexPath) as! MomentTableViewCell
        cell.moment = MomentManager.downloadedMoments[indexPath.row]
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scroll view did end dragging.")
        if (!UserStateManager.userIsLoggedIn && !UserStateManager.userRefusedToLogin && !UserStateManager.showingSignInAlert) {
            NotificationCenter.default.post(name: NSNotification.Name(SignInSignUpNotificationName.needsToSignInOrSignUp.rawValue), object: nil)
            print("Sent out needsToSignInOrSignUp notification.")
        }
    }
    
}
