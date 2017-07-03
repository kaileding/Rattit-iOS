//
//  ComposeContentDelegate.swift
//  Rattit
//
//  Created by DINGKaile on 6/27/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

protocol ComposeContentUpdateSelectedPhotosDelegate: class {
    func updatePhotoCollectionCells()
}

protocol ComposeContentUpdateSelectedUsersDelegate: class {
    func updateSelectedGroup()
}
