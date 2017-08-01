//
//  QuestionDetailsViewController.swift
//  Rattit
//
//  Created by DINGKaile on 7/30/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import UIKit

class QuestionDetailsViewController: UIViewController {
    
    @IBOutlet weak var dataTableView: UITableView!
    
    
    var questionId: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.dataTableView.dataSource = self
        self.dataTableView.delegate = self
        let questionDetailsCellNib = UINib(nibName: "QuestionDetailsTableViewCell", bundle: nil)
        self.dataTableView.register(questionDetailsCellNib, forCellReuseIdentifier: "QuestionDetailsTableViewCell")
        self.dataTableView.rowHeight = UITableViewAutomaticDimension
        self.dataTableView.estimatedRowHeight = 65.0
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

extension QuestionDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questionId == nil {
            return 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionDetailsTableViewCell", for: indexPath) as! QuestionDetailsTableViewCell
        
        let question = QuestionManager.sharedInstance.downloadedContents[self.questionId!]
        cell.initializeData(question: question!)
        
        return cell
    }
}


