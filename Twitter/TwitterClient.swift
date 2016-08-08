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
let twitterAppConsumerKey = "eNLJh17khyH9BViZi3HZVt3zX" //"BVwcFZuRapp7oF0uL1WPkMIGi"
let twitterAppConsumerSecret = "r39wiGsY8COnseBYfpi7MBfaDyAAO4Iqy9YAh69SXe8b3JruNQ" //"XSFo3AwoK3iS435SgUKYkCu5STtxUKBKL7koAbJeKmIvurmkn5"

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
    
    func logout() -> Void {
        User.currentUser = nil
        super.deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName("UserLogout", object: nil)
        
    }
    func handleOpenUrl(url : NSURL) -> Void {
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
                    User.currentUser = user // Calls setter method
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
    
    func postTweet(tweet : String) {
        let twitterClient = TwitterClient.sharedInstance
        let tweetPostRelativeEndpoint = "1.1/statuses/update.json"
        var requestParameters : [String : String] = [:]
        requestParameters["status"] = tweet
        twitterClient.POST(tweetPostRelativeEndpoint,
                parameters: requestParameters,
                progress: nil,
                success: { (request : NSURLSessionDataTask, response : AnyObject?) in
                    print("successfully posted tweet ... \(tweet)")
                })
                { (request : NSURLSessionDataTask?, error : NSError) in
                    print("[ERROR] \(error)")
                }
    }
    
    func postTweetForReply(tweet : String, parentTweetId : String) {
        let twitterClient = TwitterClient.sharedInstance
        let tweetPostRelativeEndpoint = "1.1/statuses/update.json"
        var requestParameters : [String : String] = [:]
        requestParameters["status"] = tweet
        requestParameters["in_reply_to_status_id"] = parentTweetId
        twitterClient.POST(tweetPostRelativeEndpoint,
                           parameters: requestParameters,
                           progress: nil,
                           success: { (request : NSURLSessionDataTask, response : AnyObject?) in
                            print("successfully posted tweet for reply ... \(tweet)")
            })
        { (request : NSURLSessionDataTask?, error : NSError) in
            print("[ERROR] \(error)")
        }
    }

    func fetchMentionsTimelineWithParams(success : (tweets : [Tweet]) -> (), failure : (error : NSError) -> (), parameters : [String : String]) {
        let twitterClient = TwitterClient.sharedInstance
        let mentionsTimelineRelativeEndpoint = "1.1/statuses/mentions_timeline.json"
        twitterClient.GET(
            mentionsTimelineRelativeEndpoint,
            parameters: parameters,
            progress: nil,
            success: { (request : NSURLSessionDataTask, response :AnyObject?) in
                let tweetDictionaries = response as! [NSDictionary]
                let tweets = Tweet.toTweets(tweetDictionaries)
                success(tweets: tweets)
            },
            failure: { (request : NSURLSessionDataTask?, error : NSError) in
                print("fetch user timeline with params failed ... ")
                print("request\(request!.debugDescription), error : \(error.localizedDescription)")
        })
    }

    func fetchUserTimelineWithParams(success : (tweets : [Tweet]) -> (), failure : (error : NSError) -> (), parameters : [String : String]) {
        let twitterClient = TwitterClient.sharedInstance
        let userTimelineRelativeEndpoint = "1.1/statuses/user_timeline.json"
        twitterClient.GET(
            userTimelineRelativeEndpoint,
            parameters: parameters,
            progress: nil,
            success: { (request : NSURLSessionDataTask, response :AnyObject?) in
                let tweetDictionaries = response as! [NSDictionary]
                let tweets = Tweet.toTweets(tweetDictionaries)
                success(tweets: tweets)
            },
            failure: { (request : NSURLSessionDataTask?, error : NSError) in
                print("fetch user timeline with params failed ... ")
                print("request\(request!.debugDescription), error : \(error.localizedDescription)")
        })
    }

    func fetchHomeTimelineWithParams(success : (tweets : [Tweet]) -> (), failure : (error : NSError) -> (), parameters : [String : String]) {
        let twitterClient = TwitterClient.sharedInstance
        let homeTimelineRelativeEndpoint = "1.1/statuses/home_timeline.json"
        twitterClient.GET(
            homeTimelineRelativeEndpoint,
            parameters: parameters,
            progress: nil,
            success: { (request : NSURLSessionDataTask, response :AnyObject?) in
                let tweetDictionaries = response as! [NSDictionary]
                let tweets = Tweet.toTweets(tweetDictionaries)
                success(tweets: tweets)
            },
            failure: { (request : NSURLSessionDataTask?, error : NSError) in
                print("fetch home timeline with params failed ... ")
                print("request\(request!.debugDescription), error : \(error.localizedDescription)")
        })
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
            },
            failure: { (request : NSURLSessionDataTask?, error : NSError) in
                print("fetch home timeline failed ... ")
                print("request\(request?.description), error : \(error.localizedDescription)")
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
    
    func retweet(tweetId : String) -> Void {
        let twitterClient = TwitterClient.sharedInstance
        let retweetRelativeEndpoint = "1.1/statuses/retweet/\(tweetId).json"
        twitterClient.POST(retweetRelativeEndpoint,
                parameters: nil,
                progress: nil,
                success: { (request : NSURLSessionDataTask, response : AnyObject?) in
                    print("successfully retweeted ... \(tweetId)")
                })
                { (request : NSURLSessionDataTask?, error : NSError) in
                    print("[ERROR] \(error)")
        }
    }
    
    func unRetweet(tweetId : String) -> Void {
        let twitterClient = TwitterClient.sharedInstance
        let retweetRelativeEndpoint = "1.1/statuses/unretweet/\(tweetId).json"
        twitterClient.POST(retweetRelativeEndpoint,
                           parameters: nil,
                           progress: nil,
                           success: { (request : NSURLSessionDataTask, response : AnyObject?) in
                            print("successfully un-retweeted ... \(tweetId)")
            })
        { (request : NSURLSessionDataTask?, error : NSError) in
            print("[ERROR] \(error)")
        }
    }

    func favorite(tweetId : String) -> Void {
        let twitterClient = TwitterClient.sharedInstance
//        1.1/favorites/create.json?id=759662585859874816
        let favoriteRelativeEndpoint = "1.1/favorites/create.json"
        var requestParameters : [String : String] = [:]
        requestParameters["id"] = tweetId
        twitterClient.POST(favoriteRelativeEndpoint,
                           parameters: requestParameters,
                           progress: nil,
                           success: { (request : NSURLSessionDataTask, response : AnyObject?) in
                            print("successfully favourited ... \(tweetId)")
            })
        { (request : NSURLSessionDataTask?, error : NSError) in
            print("[ERROR] \(error)")
        }
    }
    
    func unfavorite(tweetId : String) -> Void {
        let twitterClient = TwitterClient.sharedInstance
        //        1.1/favorites/create.json?id=759662585859874816
        let unfavoriteRelativeEndpoint = "1.1/favorites/destroy.json"
        var requestParameters : [String : String] = [:]
        requestParameters["id"] = tweetId
        twitterClient.POST(unfavoriteRelativeEndpoint,
                           parameters: requestParameters,
                           progress: nil,
                           success: { (request : NSURLSessionDataTask, response : AnyObject?) in
                            print("successfully unfavorited ... \(tweetId)")
            })
        { (request : NSURLSessionDataTask?, error : NSError) in
            print("[ERROR] \(error)")
        }
    }

}
