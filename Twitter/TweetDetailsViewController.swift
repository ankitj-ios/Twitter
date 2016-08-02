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
    
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBAction func onReplyButtonTap(sender: AnyObject) {
        print("reply button tapped ... ")
        // need to send notification about this event.
    }
        
    
    @IBAction func onRetweetButtonTap(sender: AnyObject) {
        print("retweet button tapped ... ")
        // need to send notification about this event.
    }
    
    
    @IBAction func onFavoriteButtonTap(sender: AnyObject) {
        print("favorite button tapped ... ")
        // need to send notification about this event.
    }
    
    @IBAction func onDeleteButtonTap(sender: AnyObject) {
        print("delete button tapped ... ")
        // need to send notification about this event.
    }
    
    var tweet : Tweet?
    var tweetCell : TweetCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImageView.layer.cornerRadius = 4
        userProfileImageView.clipsToBounds = true
        populateData()
    }
    
    func populateData() {
        if let userProfileImageUrl = self.tweet!.tweetUser?.profileImageUrl {
            let userProfileImageRequest = NSURLRequest(URL: userProfileImageUrl)
            self.userProfileImageView.setImageWithURLRequest(userProfileImageRequest, placeholderImage: nil, success: { (userProfileImageRequest, userProfileImageResponse, userProfileImage) in
                self.userProfileImageView.image = userProfileImage
            }) { (userProfileImageRequest, userProfileImageResponse, error) in
                print(error)
            }
        }
        userNameLabel.text = tweet!.tweetUser?.userName
        userScreenNameLable.text = "@\(tweet!.tweetUser!.userScreenName!)"
        tweetLabel.text = tweet!.tweetText
        self.retweetCountLabel.text = String(tweet!.retweetCount!)
        if tweet!.isRetweeted {
            retweetButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        } else {
            retweetButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        self.favoriteCountLabel.text = String(tweet!.favouriteCount!)
        if tweet!.isFavorited {
            favoriteButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        } else {
            favoriteButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        self.timeLable.text = TwitterUtils.getStringFromDate(tweet!.tweetCreatedDate!)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

