//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Ankit Jasuja on 7/31/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var userProfileImageView: UIImageView!
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userScreenNameLable: UILabel!
    
    
    var tweet : Tweet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateData()
    }
    
    func populateData() {
        userNameLabel.text = tweet?.tweetUser?.userName
        userScreenNameLable.text = tweet?.tweetUser?.userScreenName
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

