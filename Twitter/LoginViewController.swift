//
//  LoginViewController.swift
//  Twitter
//
//  Created by Ankit Jasuja on 7/29/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginButton(sender: AnyObject) {
        print("login with twitter ... ")
        
        let twitterBaseUrl = NSURL(string: "https://api.twitter.com")
        let twitterAppConsumerKey = "BVwcFZuRapp7oF0uL1WPkMIGi"
        let twitterAppConsumerSecret = "XSFo3AwoK3iS435SgUKYkCu5STtxUKBKL7koAbJeKmIvurmkn5"
        
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
            }
    }
    
}
