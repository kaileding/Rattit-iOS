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
    
    
    var momentId: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dataTableView.dataSource = self
        self.dataTableView.delegate = self
        let momentDetailsCellNib = UINib(nibName: "MomentDetailsTableViewCell", bundle: nil)
        self.dataTableView.register(momentDetailsCellNib, forCellReuseIdentifier: "MomentDetailsTableViewCell")
        self.dataTableView.rowHeight = UITableViewAutomaticDimension
        self.dataTableView.estimatedRowHeight = 65.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.dataTableView.reloadData()
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
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MomentDetailsTableViewCell", for: indexPath) as! MomentDetailsTableViewCell
        
        let moment = MomentManager.sharedInstance.downloadedContents[self.momentId!]
        cell.initializeData(moment: moment!)
        
        return cell
    }
}


