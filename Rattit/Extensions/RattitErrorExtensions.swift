//
//  RattitErrorExtensions.swift
//  Rattit
//
//  Created by DINGKaile on 6/22/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

struct RattitError: Error {
    var errorInfo: String! = ""
    var type: String! = ""
    
    init(type: String, message: String) {
        self.type = type
        self.errorInfo = message
    }
    
    var localizedDescription: String {
        return self.errorInfo
    }
    
    static func defultError(message: String) -> RattitError {
        return RattitError(type: "defaultError", message: message)
    }
    
    static func parseError(message: String) -> RattitError {
        return RattitError(type: "parseError", message: message)
    }
    
    static func netWorkError(message: String) -> RattitError {
        return RattitError(type: "networkError", message: message)
    }
    
    static func caseError(message: String) -> RattitError {
        return RattitError(type: "caseError", message: message)
    }
    
}
