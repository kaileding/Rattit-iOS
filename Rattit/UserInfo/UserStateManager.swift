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
    
    var dummyUserId: String = "e5b89946-4db4-11e7-b114-b2f933d5fe66"
    var dummyUser: RattitUser? = nil
    var dummyMyFollowers: [String] = [] // array of userIds
    var dummyMyFollowees: [String] = [] // array of userIds
    var dummyMyFriends: [String] = [] // array of userIds
    var dummyMyMoments: [String] = [] // array of momentIds
    
    static let sharedInstance: UserStateManager = UserStateManager()
    
    func loadMyCurrentInformation() {
        
        RattitUserManager.sharedInstance.getRattitUserForId(id: self.dummyUserId, completion: { (rattitUser) in
            
            UserStateManager.sharedInstance.dummyUser = rattitUser
        }) { (error) in
            print("== Unable to load user for id = \(self.dummyUserId) as myself. \(error.localizedDescription)")
        }
        
        RattitUserManager.sharedInstance.getFollowersOrFolloweesOfUser(userId: self.dummyUserId, relationType: .follower, completion: { (totalNum, userGroup) in
            
            self.dummyMyFollowers = userGroup
        }) { (error) in
            print("== Unable to load followers of mine. \(error.localizedDescription)")
        }
        
        RattitUserManager.sharedInstance.getFollowersOrFolloweesOfUser(userId: self.dummyUserId, relationType: .followee, completion: { (totalNum, userGroup) in
            
            self.dummyMyFollowees = userGroup
        }) { (error) in
            print("== Unable to load followees of mine. \(error.localizedDescription)")
        }
        
        RattitUserManager.sharedInstance.getFollowersOrFolloweesOfUser(userId: self.dummyUserId, relationType: .friends, completion: { (totalNum, userGroup) in
            
            self.dummyMyFriends = userGroup
        }) { (error) in
            print("== Unable to load friends of mine. \(error.localizedDescription)")
        }
        
        MomentManager.sharedInstance.getMomentsCreatedByAUser(userId: self.dummyUserId, completion: { (momentGroup) in
            
            self.dummyMyMoments = momentGroup
        }) { (error) in
            print("== Unable to load moments of mine. \(error.localizedDescription)")
        }
    }
    
}
