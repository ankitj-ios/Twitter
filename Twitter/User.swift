//
//  User.swift
//  Twitter
//
//  Created by Ankit Jasuja on 7/29/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

//var _currentUser : User?

class User: NSObject {

    var userId : Int?
    var userIdString : String?
    var userName : String?
    var userScreenName : String?
    var userDescription : String?
    var followersCount  : Int
    var friendsCount : Int
    var profileImageUrl : NSURL?
    var createdAt : NSDate?
    
    var dictionary : NSDictionary
    
    init(dictionary : NSDictionary) {
        self.dictionary = dictionary
        
        userId = dictionary["id"] as? Int
        userIdString = dictionary["id_str"] as? String
        userName = dictionary["name"] as? String
        userScreenName = dictionary["screen_name"] as? String
        userDescription = dictionary["description"] as? String
        followersCount = dictionary["followers_count"] as? Int ?? 0
        friendsCount = dictionary["friends_count"] as? Int ?? 0
        profileImageUrl = NSURL(string: dictionary["profile_image_url_https"] as! String)
    }
    
    
    static var _currentUser : User?
    
    class var currentUser : User? {
        get {
            print("user getter called ... ")
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                if let userData = userData {
                    let userDictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as!NSDictionary
                    _currentUser = User(dictionary: userDictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            print("user setter called ... ")
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let userData = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
                defaults.setObject(userData, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
