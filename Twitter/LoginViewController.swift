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
        TwitterClient.sharedInstance.login({ (user : User) in
            print("logged in ... \(user.userName)")
//            self.performSegueWithIdentifier("TweetsViewController", sender: nil)
            self.performSegueWithIdentifier("HamburgerViewControllerSegue", sender: nil)
        }) { (error : NSError) in
            print("error ... \(error.localizedDescription)")
        }
    }
    
}
