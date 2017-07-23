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
    var downloadedUnits: [String: MainContent] = [:] // mainContentId : MainContent
    var displaySequenceOfQuestions: [String] = [] // Array of questionId
    var lastQuestionCreatedAt: Date? = nil
    var lastQuestionId: String? = nil
    var firstQuestionCreatedAt: Date? = nil
    var firstQuestionId: String? = nil
    var lastRefreshTime: Date? = nil
    
    static let sharedInstance: QuestionManager = QuestionManager()
    
    func loadUnitsFromServer(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        
        
    }
    
    func loadUnitUpdatesFromServer(completion: @escaping (Bool) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        if (self.lastQuestionCreatedAt != nil) {
            
            
        } else {
            print("lastQuestionCreatedAt = nil, so loadQuestionsFromServer() func called.")
        }
        
    }
    
}
