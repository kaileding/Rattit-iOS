//
//  ContentDisplayTableView.swift
//  Rattit
//
//  Created by DINGKaile on 7/17/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class ContentDisplayTableView: UIView, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var contentTableView: UITableView!
    
    
    static func instantiateFromXib() -> ContentDisplayTableView {
        let contentDisplayTableView = Bundle.main.loadNibNamed("ContentDisplayTableView", owner: self, options: nil)?.first as! ContentDisplayTableView
        
        contentDisplayTableView.translatesAutoresizingMaskIntoConstraints = false
        contentDisplayTableView.contentTableView.translatesAutoresizingMaskIntoConstraints = false
        contentDisplayTableView.contentTableView.topAnchor.constraint(equalTo: contentDisplayTableView.topAnchor, constant: 0.0).isActive = true
        contentDisplayTableView.contentTableView.leadingAnchor.constraint(equalTo: contentDisplayTableView.leadingAnchor, constant: 0.0).isActive = true
        contentDisplayTableView.contentTableView.trailingAnchor.constraint(equalTo: contentDisplayTableView.trailingAnchor, constant: 0.0).isActive = true
        contentDisplayTableView.contentTableView.bottomAnchor.constraint(equalTo: contentDisplayTableView.bottomAnchor, constant: 0.0).isActive = true
        
        contentDisplayTableView.contentTableView.dataSource = contentDisplayTableView
        contentDisplayTableView.contentTableView.delegate = contentDisplayTableView
        contentDisplayTableView.contentTableView.estimatedRowHeight = 44.0
        contentDisplayTableView.contentTableView.rowHeight = UITableViewAutomaticDimension
        let momentCellNib = UINib(nibName: "MomentTableViewCell", bundle: nil)
        contentDisplayTableView.contentTableView.register(momentCellNib, forCellReuseIdentifier: "MomentTableViewCell")
        
        return contentDisplayTableView
    }
    
    func initializeData(backgroundColor: UIColor) {
        self.contentTableView.backgroundColor = backgroundColor
        self.layoutIfNeeded()
        self.sizeToFit()
        self.contentTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserStateManager.sharedInstance.dummyMyMoments.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentTableViewCell", for: indexPath) as! MomentTableViewCell
        
        let displayMomentId = UserStateManager.sharedInstance.dummyMyMoments[indexPath.row]
        cell.initializeContent(moment: MomentManager.sharedInstance.downloadedMoments[displayMomentId]!, sideLength: Double(self.frame.width))
        
        print("tableView(:cellForRowAt:) func. self.frame.width is \(self.frame.width)")
        
        return cell
    }
    

}
