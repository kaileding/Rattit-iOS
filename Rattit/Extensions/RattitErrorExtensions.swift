//
//  RattitErrorExtensions.swift
//  Rattit
//
//  Created by DINGKaile on 6/22/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

class RattitError: Error {
    var errorInfo: String! = ""
    
    init(message: String) {
        self.errorInfo = message
    }
    
}
