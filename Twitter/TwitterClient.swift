//
//  TwitterClient.swift
//  Twitter
//
//  Created by Ankit Jasuja on 7/29/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterBaseUrl = NSURL(string: "https://api.twitter.com")
let twitterAppConsumerKey = "BVwcFZuRapp7oF0uL1WPkMIGi"
let twitterAppConsumerSecret = "XSFo3AwoK3iS435SgUKYkCu5STtxUKBKL7koAbJeKmIvurmkn5"

class TwitterClient: BDBOAuth1SessionManager {

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(
                baseURL: twitterBaseUrl,
                consumerKey: twitterAppConsumerKey,
                consumerSecret: twitterAppConsumerSecret)
        }
        return Static.instance
    }

    var loginSuccess : ((user : User) -> ())?
    var loginFailure : ((error : NSError) -> ())?
    
    func login(success : (user : User) -> (), failure : (error : NSError) -> ()) -> Void {
        self.loginSuccess = success
        self.loginFailure = failure
        
        let twitterClient = BDBOAuth1SessionManager(
            baseURL: twitterBaseUrl,
            consumerKey: twitterAppConsumerKey,
            consumerSecret: twitterAppConsumerSecret)
        
        let requestTokenRelativePath = "oauth/request_token"
        
        let twitterAppCallbackEndpoint = "twitterApp://oauth"
        let twitterAppCallbackUrl = NSURL(string: twitterAppCallbackEndpoint)
        
        twitterClient.deauthorize()
        
        twitterClient.fetchRequestTokenWithPath(
            requestTokenRelativePath,
            method: "GET",
            callbackURL: twitterAppCallbackUrl,
            scope: nil,
            success: { (requestToken : BDBOAuth1Credential!) in
                print("got request token successfully ... ")
                let twitterAuthorizeEndpoint = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)"
                let twitterAuthorizeUrl = NSURL(string: twitterAuthorizeEndpoint)
                UIApplication.sharedApplication().openURL(twitterAuthorizeUrl!)
        }) { (error : NSError!) in
            print(error.localizedDescription)
            self.loginFailure?(error: error)
        }
    }
    
    func handleOpenUrl(url : NSURL) -> Void {
//        let twitterBaseUrl = NSURL(string: "https://api.twitter.com")
//        let twitterAppConsumerKey = "BVwcFZuRapp7oF0uL1WPkMIGi"
//        let twitterAppConsumerSecret = "XSFo3AwoK3iS435SgUKYkCu5STtxUKBKL7koAbJeKmIvurmkn5"
        
        
        let twitterClient = BDBOAuth1SessionManager(
            baseURL: twitterBaseUrl,
            consumerKey: twitterAppConsumerKey,
            consumerSecret: twitterAppConsumerSecret)
        
        let accessTokenRelativePath = "oauth/access_token"
        let requestTokenCredential = BDBOAuth1Credential(queryString: url.query)
        twitterClient.fetchAccessTokenWithPath(
            accessTokenRelativePath,
            method: "POST",
            requestToken: requestTokenCredential,
            success: { (accessToken : BDBOAuth1Credential!) in
                print("got access token successfully ... ")
                self.fetchCurrentUser({ (user : User) in
                self.loginSuccess?(user: user)
            },
            failure: { (error : NSError) in
                    self.loginFailure?(error: error)
                })
        }) { (error : NSError!) in
            print("error : \(error.localizedDescription)")
            self.loginFailure?(error: error)
        }

    }
    
    
    func fetchHomeTimeline(success : (tweets : [Tweet]) -> (), failure : (error : NSError) -> ()) {
        let twitterClient = TwitterClient.sharedInstance
        let homeTimelineRelativeEndpoint = "1.1/statuses/home_timeline.json"
        twitterClient.GET(
            homeTimelineRelativeEndpoint,
            parameters: nil,
            progress: nil,
            success: { (request : NSURLSessionDataTask, response :AnyObject?) in
                let tweetDictionaries = response as! [NSDictionary]
                let tweets = Tweet.toTweets(tweetDictionaries)
                success(tweets: tweets)
//                success(tweets: tweets)
//                for tweetDictionary in tweetDictionaries {
//                    let tweet = Tweet(tweetDictionary : tweetDictionary);
//                    success(tweets: tweets)
//                }
            },
            failure: { (request : NSURLSessionDataTask?, error : NSError) in
                print("error : \(error.localizedDescription)")
        })
    }
    
    func fetchCurrentUser(success : (user : User) -> (), failure : (error : NSError) -> ()) {
        let twitterClient = TwitterClient.sharedInstance
        let currentUserRelativeEndpoint = "1.1/account/verify_credentials.json"
        twitterClient.GET(
            currentUserRelativeEndpoint,
            parameters: nil,
            progress: nil,
            success: { (request : NSURLSessionDataTask, response :AnyObject?) in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                success(user: user)
            },
            failure: { (request : NSURLSessionDataTask?, error : NSError) in
                print("error : \(error.localizedDescription)")
                failure(error: error)
        })
    }

}
