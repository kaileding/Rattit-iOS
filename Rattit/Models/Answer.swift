//
//  Answer.swift
//  Rattit
//
//  Created by DINGKaile on 6/21/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

class Answer: MainContent {
    var id: String?
    var createdBy: String?
    var createdAt: Date?
    var createdByInfo: RattitUser?
    var dataFlowContentUnit: DataFlowContentUnit?
    
    var forQuestion: String!
    var words: String!
    var agreeNumber: Int = 0
    var disagreeNumber: Int = 0
    var admirersNumber: Int = 0
    var rankScore: Int = 0
    
    // optional fields
    var questionTitle: String? = nil
    var photos: [Photo]? = nil
    var hashTags: [String]? = nil
    var attachmentUrl: String? = nil
    
//    static func parseFromJson(dataValue: Any) -> MainContent? {
//        return Answer(dataValue: dataValue)
//    }
    
    required init?(dataValue: Any) {
        guard let json = dataValue as? [String: Any],
            let id = json["id"] as? String,
            let forQuestion = json["for_question"] as? String,
            let createdBy = json["createdBy"] as? String,
            let createdAtStr = json["createdAt"] as? String,
            let createdAt = createdAtStr.utcStringToDate,
            let words = json["words"] as? String,
            let agreeNumber = json["agree_number"] as? Int,
            let disagreeNumber = json["disagree_number"] as? Int,
            let admirersNumber = json["admirer_number"] as? Int,
            let rankScore = json["rank_score"] as? Int
            else {
                return nil
        }
        
        self.id = id
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.dataFlowContentUnit = DataFlowContentUnit(contentType: .answer, id: id, createdAt: createdAt)
        
        self.forQuestion = forQuestion
        self.words = words
        self.agreeNumber = agreeNumber
        self.disagreeNumber = disagreeNumber
        self.admirersNumber = admirersNumber
        self.rankScore = rankScore
        
        if let question = json["question"] as? [String: Any] {
            if let questionTitle = question["title"] as? String {
                self.questionTitle = questionTitle
            }
        }
        
        if let photosDataValues = json["photos"] as? [Any] {
            var tempPhotos: [Photo] = []
            photosDataValues.forEach { (photoData) in
                if let tempPhoto = Photo(dataValue: photoData) {
                    tempPhotos.append(tempPhoto)
                }
            }
            self.photos = tempPhotos
        }
        if let hashTags = json["hash_tags"] as? [String] {
            self.hashTags = hashTags
        }
        if let attachmentUrl = json["attachment"] as? String {
            self.attachmentUrl = attachmentUrl
        }
        
        // additional information
        if let rattitUserObj = json["rattit_user"] {
            self.createdByInfo = RattitUser(dataValue: rattitUserObj)
        }
        
    }
    
    init(forQuestion: String, words: String, createdBy: String) {
        self.forQuestion = forQuestion
        self.words = words
        self.id = nil
        self.createdBy = createdBy
        self.createdAt = nil
        self.dataFlowContentUnit = nil
    }
}
