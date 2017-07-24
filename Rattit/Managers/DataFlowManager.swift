//
//  DataFlowManager.swift
//  Rattit
//
//  Created by DINGKaile on 7/23/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import Alamofire

class DataFlowManager: NSObject {
    var allContentUnits: [DataFlowContentUnit] = []
    var lastRefreshTime: Date? = nil
    
    static let sharedInstance: DataFlowManager = DataFlowManager()
    
    func loadUnitsFromServer(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        self.lastRefreshTime = Date()
        let group = DispatchGroup()
        group.enter()
        MomentManager.sharedInstance.loadMomentsFromServer(completion: {
            group.leave()
        }) { (error) in
            print("in DataFlowManager, MomentManager.loadMomentsFromServer() failed. \(error.localizedDescription)")
            group.leave()
        }
        
        group.enter()
        QuestionManager.sharedInstance.loadQuestionsFromServer(completion: {
            group.leave()
        }) { (error) in
            print("in DataFlowManager, QuestionManager.loadQuestionsFromServer() failed. \(error.localizedDescription)")
            group.leave()
        }
        
        group.enter()
        AnswerManager.sharedInstance.loadAnswersFromServer(completion: {
            group.leave()
        }) { (error) in
            print("in DataFlowManager, AnswerManager.loadAnswersFromServer() failed. \(error.localizedDescription)")
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.allContentUnits.removeAll()
            self.allContentUnits.append(contentsOf: MomentManager.sharedInstance.displaySequenceOfContents)
            self.allContentUnits.append(contentsOf: QuestionManager.sharedInstance.displaySequenceOfContents)
            self.allContentUnits.append(contentsOf: AnswerManager.sharedInstance.displaySequenceOfContents)
            print("in DataFlowManager, Totally got \(self.allContentUnits.count) content units.")
            
            self.allContentUnits.sort(by: { (left, right) -> Bool in
                return left.createdAt.compare(right.createdAt) == .orderedAscending
            })
            
            completion()
        }
        
    }
    
    func loadUnitUpdatesFromServer(completion: @escaping (Bool) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        
    }
    
}
