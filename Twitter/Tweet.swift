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
        
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "Fri Jul 29 01:00:17 +0000 2016"
        tweetCreatedDate = dateformatter.dateFromString(tweetDictionary["created_at"] as! String)

        isTweetTruncated = tweetDictionary["truncated"] as! Bool
        tweetUser = User(dictionary: tweetDictionary["user"] as! NSDictionary)
        retweetCount = tweetDictionary["retweet_count"] as? Int
        favouriteCount = tweetDictionary["favorite_count"] as? Int
        isRetweeted = tweetDictionary["retweeted"] as! Bool
        isFavorited = tweetDictionary["favorited"] as! Bool
    }
    
    class func toTweets(tweetDictionaries : [NSDictionary]) -> [Tweet] {
        var tweets : [Tweet] = []
        for tweetDictionary in tweetDictionaries {
            tweets.append(Tweet(tweetDictionary: tweetDictionary))
        }
        return tweets
    }
    
}
