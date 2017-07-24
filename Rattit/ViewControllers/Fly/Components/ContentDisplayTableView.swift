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
    
    var contentType: RattitContentType! = .moment
    
//    var resizeTopHeaderViewHeightDelegate: ResizeTableViewHeaderDelegate? = nil
    var parentVC: FlyHomeViewController? = nil
    var lastScrollOffset: CGPoint = CGPoint.zero
    
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
        let questionCellNib = UINib(nibName: "QuestionTableViewCell", bundle: nil)
        contentDisplayTableView.contentTableView.register(questionCellNib, forCellReuseIdentifier: "QuestionTableViewCell")
        let answerCellNib = UINib(nibName: "AnswerTableViewCell", bundle: nil)
        contentDisplayTableView.contentTableView.register(answerCellNib, forCellReuseIdentifier: "AnswerTableViewCell")
        
        return contentDisplayTableView
    }
    
    func initializeData(contentType: RattitContentType, backgroundColor: UIColor) {
        self.contentType = contentType
        self.contentTableView.backgroundColor = backgroundColor
        self.layoutIfNeeded()
        self.sizeToFit()
        self.contentTableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.contentType {
        case .moment:
            return UserStateManager.sharedInstance.dummyMyMoments.count
        case .question:
            return UserStateManager.sharedInstance.dummyMyQuestions.count
        case .answer:
            return UserStateManager.sharedInstance.dummyMyAnswers.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sideLength = Double(self.frame.width)
        switch self.contentType {
        case .moment:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MomentTableViewCell", for: indexPath) as! MomentTableViewCell
            
            let displayMomentId = UserStateManager.sharedInstance.dummyMyMoments[indexPath.row]
            cell.initializeContent(moment: MomentManager.sharedInstance.downloadedContents[displayMomentId]!, sideLength: sideLength)
            
            return cell
        case .question:
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
            
            let displayQuestionId = UserStateManager.sharedInstance.dummyMyQuestions[indexPath.row]
            cell.initializeContent(question: QuestionManager.sharedInstance.downloadedContents[displayQuestionId]!, sideLength: sideLength)
            
            return cell
        case .answer:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerTableViewCell", for: indexPath) as! AnswerTableViewCell
            
            let displayAnswerId = UserStateManager.sharedInstance.dummyMyAnswers[indexPath.row]
            cell.initializeContent(answer: AnswerManager.sharedInstance.downloadedContents[displayAnswerId]!, sideLength: sideLength)
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: false)
        return nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - self.lastScrollOffset.y
//        print("scrollDiff = \(scrollDiff), contentOffset.y = \(scrollView.contentOffset.y)")
        if scrollDiff < 0 && scrollView.contentOffset.y < 0 { // scrolling down, may expand header
            if self.parentVC != nil && self.parentVC!.profileHeaderTopConstraint.constant < 0 {
                self.parentVC!.resizeTableHeaderViewHeight(step: scrollDiff)
                self.contentTableView.contentOffset = self.lastScrollOffset
            }
        } else if scrollDiff > 0 && scrollView.contentOffset.y > 0 { // scrolling up, may collapse header
            if self.parentVC != nil && self.parentVC!.profileHeaderTopConstraint.constant > -self.parentVC!.profileHeaderHeight {
                self.parentVC!.resizeTableHeaderViewHeight(step: scrollDiff)
                self.contentTableView.contentOffset = self.lastScrollOffset
            }
        }
        
        self.lastScrollOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.parentVC != nil {
            self.parentVC!.continueVerticalSliding()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && self.parentVC != nil {
            self.parentVC!.continueVerticalSliding()
        }
    }

}

extension ContentDisplayTableView {
    
}
