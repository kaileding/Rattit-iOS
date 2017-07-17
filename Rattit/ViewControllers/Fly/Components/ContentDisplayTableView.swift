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
        contentDisplayTableView.contentTableView.dataSource = contentDisplayTableView
        contentDisplayTableView.contentTableView.delegate = contentDisplayTableView
        
        return contentDisplayTableView
    }
    
    func initializeData(backgroundColor: UIColor) {
        self.contentTableView.backgroundColor = backgroundColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    

}
