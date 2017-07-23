//
//  AnswerManager.swift
//  Rattit
//
//  Created by DINGKaile on 7/23/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation
import Alamofire

//class AnswerManager: NSObject {
//    var downloadedAnswers: [String: Answer] = [:] // answerId : Answer
//    var displaySequenceOfAnswers: [String] = [] // Array of answerId
//    var lastQuestionCreatedAt: Date? = nil
//    var lastQuestionId: String? = nil
//    var firstQuestionCreatedAt: Date? = nil
//    var firstQuestionId: String? = nil
//    var lastRefreshTime: Date? = nil
//
//    static let sharedInstance: QuestionManager = QuestionManager()
//
//    func loadQuestionsFromServer(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
//
//        Network.sharedInstance.callRattitContentService(httpRequest: .GetQuestions, completion: { (dataValue) in
//
//            if let responseBody = dataValue as? [String: Any], let count = responseBody["count"] as? Int, let rows = responseBody["rows"] as? [Any] {
//
//                print("Got \(count) questions from server.")
//                self.downloadedQuestions.removeAll()
//                self.displaySequenceOfQuestions.removeAll()
//                for rowValue in rows {
//                    if let qeustion = Question(dataValue: rowValue) {
//                        self.downloadedQuestions[qeustion.id!] = qeustion
//                        self.displaySequenceOfQuestions.append(qeustion.id!)
//                        if let questionAuthor = qeustion.createdByInfo, let authorId = qeustion.createdBy {
//                            RattitUserManager.sharedInstance.cachedUsers[authorId] = questionAuthor
//                        }
//                    }
//                }
//                if let lastQuestionId = self.displaySequenceOfQuestions.first {
//                    self.lastQuestionCreatedAt = self.downloadedQuestions[lastQuestionId]!.createdAt
//                    self.lastQuestionId = lastQuestionId
//                }
//                if let firstQuestionId = self.displaySequenceOfQuestions.last {
//                    self.firstQuestionCreatedAt = self.downloadedQuestions[firstQuestionId]!.createdAt
//                    self.firstQuestionId = firstQuestionId
//                }
//
//                DispatchQueue.main.async {
//                    self.lastRefreshTime = Date()
//                    completion()
//                }
//            } else {
//                DispatchQueue.main.async {
//                    errorHandler(RattitError.parseError(message: "Unable to parse response data from getting questions."))
//                }
//            }
//
//        }) { (error) in
//            errorHandler(error)
//        }
//
//    }
//
//    func loadQuestionsUpdatesFromServer(completion: @escaping (Bool) -> Void, errorHandler: @escaping (Error) -> Void) {
//
//        if (self.lastQuestionCreatedAt != nil) {
//
//            Network.sharedInstance.callRattitContentService(httpRequest: .getQuestionsNoEarlierThan(timeThreshold: self.lastQuestionCreatedAt!.dateToUtcString), completion: { (dataValue) in
//
//                if let responseBody = dataValue as? [String: Any], let count = responseBody["count"] as? Int, let rows = responseBody["rows"] as? [Any] {
//
//                    print("Got \(count) more questions from server.")
//                    if (count > 0) {
//                        var newQuetions: [String] = []
//                        rows.forEach({ (dataValue) in
//                            if let question = Question(dataValue: dataValue) {
//                                self.downloadedQuestions[question.id!] = question
//                                if (question.id != self.lastQuestionId) {
//                                    newQuetions.append(question.id!)
//                                }
//                                if let questionAuthor = question.createdByInfo, let authorId = question.createdBy {
//                                    RattitUserManager.sharedInstance.cachedUsers[authorId] = questionAuthor
//                                }
//                            }
//                        })
//                        self.displaySequenceOfQuestions.insert(contentsOf: newQuetions, at: 0)
//                        if let lastQuestionId = newQuetions.first {
//                            self.lastQuestionId = lastQuestionId
//                            self.lastQuestionCreatedAt = self.downloadedQuestions[lastQuestionId]!.createdAt
//                        }
//
//                        DispatchQueue.main.async {
//                            self.lastRefreshTime = Date()
//                            completion(newQuetions.count > 0)
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            self.lastRefreshTime = Date()
//                            completion(false)
//                        }
//                    }
//                }
//
//            }, errorHandler: { (error) in
//                errorHandler(error)
//            })
//
//        } else {
//            print("lastQuestionCreatedAt = nil, so loadQuestionsFromServer() func called.")
//            self.loadQuestionsFromServer(completion: {
//                completion(true)
//            }, errorHandler: errorHandler)
//        }
//
//    }
//
//    func getQuestionsCreatedByAUser(userId: String, completion: @escaping ([String]) -> Void, errorHandler: @escaping (Error) -> Void) {
//
//        Network.sharedInstance.callRattitContentService(httpRequest: .getQuestionsCreatedByUser(userId: userId), completion: { (dataValue) in
//
//            if let responseBody = dataValue as? [String: Any], let count = responseBody["count"] as? Int, let rows = responseBody["rows"] as? [Any] {
//
//                print("Got \(count) questions from server.")
//                var questionsOfUser: [String] = []
//                rows.forEach({ (dataValue) in
//                    if let question = Question(dataValue: dataValue) {
//                        self.downloadedQuestions[question.id!] = question
//                        questionsOfUser.append(question.id!)
//                    }
//                })
//
//                DispatchQueue.main.async {
//                    completion(questionsOfUser)
//                }
//            } else {
//                DispatchQueue.main.async {
//                    errorHandler(RattitError.parseError(message: "Unable to parse response data from getting questions."))
//                }
//            }
//
//        }) { (error) in
//            errorHandler(error)
//        }
//
//    }
//
//    func castVoteToAQuestion(questionId: String, voteType: RattitQuestionVoteType, commit: Bool, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
//
//        Network.sharedInstance.callRattitContentService(httpRequest: .castVoteToAQuestion(questionId: questionId, voteType: voteType, commit: commit), completion: { (dataValue) in
//
//            if let question = Question(dataValue: dataValue) {
//                self.downloadedQuestions[question.id!] = question
//                DispatchQueue.main.async {
//                    completion()
//                }
//            }
//        }) { (error) in
//            print("Failed to cast vote to question. Error is \(error.localizedDescription)")
//            DispatchQueue.main.async {
//                errorHandler()
//            }
//        }
//    }
//
//}
//

