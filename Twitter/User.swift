//
//  User.swift
//  Twitter
//
//  Created by Ankit Jasuja on 7/29/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

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
    
    init(dictionary : NSDictionary) {
        userId = dictionary["id"] as? Int
        userIdString = dictionary["id_str"] as? String
        userName = dictionary["name"] as? String
        userScreenName = dictionary["screen_name"] as? String
        userDescription = dictionary["description"] as? String
        followersCount = dictionary["followers_count"] as? Int ?? 0
        friendsCount = dictionary["friends_count"] as? Int ?? 0
        profileImageUrl = NSURL(string: dictionary["profile_image_url"] as! String)
    }
    
}
