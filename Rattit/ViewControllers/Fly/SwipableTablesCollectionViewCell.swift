//
//  SwipableTablesCollectionViewCell.swift
//  Rattit
//
//  Created by DINGKaile on 7/17/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class SwipableTablesCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet weak var contentTable: UITableView!
    
    var showContentInTable: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentTable.dataSource = self
        self.contentTable.delegate = self
        self.contentTable.estimatedRowHeight = 44.0
        self.contentTable.rowHeight = UITableViewAutomaticDimension
        let momentCellNib = UINib(nibName: "MomentTableViewCell", bundle: nil)
        self.contentTable.register(momentCellNib, forCellReuseIdentifier: "MomentTableViewCell")
        
    }
    
    func initializeData(tableBackgroundColor: UIColor) {
        self.contentTable.backgroundColor = tableBackgroundColor
        self.layoutIfNeeded()
        self.showContentInTable = true
        self.contentTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.showContentInTable {
            return UserStateManager.sharedInstance.dummyMyMoments.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentTableViewCell", for: indexPath) as! MomentTableViewCell
        
        let displayMomentId = UserStateManager.sharedInstance.dummyMyMoments[indexPath.row]
        cell.initializeContent(moment: MomentManager.sharedInstance.downloadedMoments[displayMomentId]!, sideLength: Double(self.contentTable.frame.width))
        
        print("self.showContentInTable is \(self.showContentInTable). tableView(:cellForRowAt:) func. self.contentTable.frame.width is \(self.contentTable.frame.width)")
        
        return cell
    }
    
    
    
}
