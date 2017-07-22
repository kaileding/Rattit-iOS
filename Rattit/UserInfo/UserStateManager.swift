//
//  UserStateManager.swift
//  Rattit
//
//  Created by DINGKaile on 6/17/17.
//  Copyright © 2017 KaileDing. All rights reserved.
//

import Foundation

class UserStateManager: NSObject {
    static var userIsLoggedIn: Bool = false
    static var userRefusedToLogin: Bool = false
    static var showingSignInAlert: Bool = false
    static var initialContentLoaded: Bool = false
    static var devicePhotoLibraryLoaded: Bool = false
    
    var dummyUserId: String = "e5b89946-4db4-11e7-b114-b2f933d5fe66"
    var dummyUser: RattitUser? = nil
    var dummyMyFollowers: [String] = [] // array of userIds
    var dummyMyFollowees: [String] = [] // array of userIds
    var dummyMyFriends: [String] = [] // array of userIds
    var dummyMyMoments: [String] = [] // array of momentIds
    
    var dummyUserInfoLoadMap: UInt8 = 0
    var dummyUserInfoLoaded: Bool {
        get {
            return (self.dummyUserInfoLoadMap == 31)
        }
    }
    
    static let sharedInstance: UserStateManager = UserStateManager()
    
    func loadMyCurrentInformation() {
        
        RattitUserManager.sharedInstance.getRattitUserForId(id: self.dummyUserId, completion: { (rattitUser) in
            
            UserStateManager.sharedInstance.dummyUser = rattitUser
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 1
        }) { (error) in
            print("== Unable to load user for id = \(self.dummyUserId) as myself. \(error.localizedDescription)")
        }
        
        RattitUserManager.sharedInstance.getFollowersOrFolloweesOfUser(userId: self.dummyUserId, relationType: .follower, completion: { (totalNum, userGroup) in
            
            self.dummyMyFollowers = userGroup
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 2
        }) { (error) in
            print("== Unable to load followers of mine. \(error.localizedDescription)")
        }
        
        RattitUserManager.sharedInstance.getFollowersOrFolloweesOfUser(userId: self.dummyUserId, relationType: .followee, completion: { (totalNum, userGroup) in
            
            self.dummyMyFollowees = userGroup
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 4
        }) { (error) in
            print("== Unable to load followees of mine. \(error.localizedDescription)")
        }
        
        RattitUserManager.sharedInstance.getFollowersOrFolloweesOfUser(userId: self.dummyUserId, relationType: .friends, completion: { (totalNum, userGroup) in
            
            self.dummyMyFriends = userGroup
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 8
        }) { (error) in
            print("== Unable to load friends of mine. \(error.localizedDescription)")
        }
        
        MomentManager.sharedInstance.getMomentsCreatedByAUser(userId: self.dummyUserId, completion: { (momentGroup) in
            
            self.dummyMyMoments = momentGroup
            UserStateManager.sharedInstance.dummyUserInfoLoadMap |= 16
        }) { (error) in
            print("== Unable to load moments of mine. \(error.localizedDescription)")
        }
    }
    
}
