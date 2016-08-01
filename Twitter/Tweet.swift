//
//  Tweet.swift
//  Twitter
//
//  Created by Ankit Jasuja on 7/29/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var tweetId : Int?
    var tweetIdString : String?
    var tweetText : String?
    var tweetCreatedDate : NSDate?
    var isTweetTruncated : Bool = false
    var tweetUser : User?
    var retweetCount : Int?
    var favouriteCount : Int?
    var isRetweeted : Bool = false
    var isFavorited : Bool = false
    
    init(tweetDictionary : NSDictionary) {
        tweetId = tweetDictionary["id"] as? Int
        tweetIdString = tweetDictionary["id_str"] as? String
        tweetText =  tweetDictionary["text"] as? String
        
        //"Fri Jul 29 01:00:17 +0000 2016"
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        
        if let createdAtString = tweetDictionary["created_at"] as? String {
            tweetCreatedDate = dateformatter.dateFromString(createdAtString)
        } else {
            tweetCreatedDate = NSDate()
        }

        isTweetTruncated = tweetDictionary["truncated"] as? Bool ?? false
        if let userDictionary = tweetDictionary["user"] as? NSDictionary {
            tweetUser = User(dictionary: userDictionary)
        } else {
            tweetUser = User.currentUser
        }
        retweetCount = tweetDictionary["retweet_count"] as? Int ?? 0
        favouriteCount = tweetDictionary["favorite_count"] as? Int ?? 0
        isRetweeted = tweetDictionary["retweeted"] as? Bool ?? false
        isFavorited = tweetDictionary["favorited"] as? Bool ?? false
    }
    
    class func toTweets(tweetDictionaries : [NSDictionary]) -> [Tweet] {
        var tweets : [Tweet] = []
        for tweetDictionary in tweetDictionaries {
            tweets.append(Tweet(tweetDictionary: tweetDictionary))
        }
        return tweets
    }
    
}
