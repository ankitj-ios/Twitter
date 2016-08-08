//
//  TweetCell.swift
//  Twitter
//
//  Created by Ankit Jasuja on 7/30/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    var tweet : Tweet?
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!
    
    @IBOutlet weak var createdAtLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = 4
        userImageView.clipsToBounds = true
        
        self.userImageView.userInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapUserImage))
        tapGestureRecognizer.delegate = self
        self.userImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func onTapUserImage() {
        print("user image tapped ... ")
        var userInfo : [String : AnyObject] = [:]
        userInfo["tweetCell"] = self
        print("user image tapped notification sent ... ")
        NSNotificationCenter.defaultCenter().postNotificationName("UserImageTapped", object: nil, userInfo: userInfo)
    }
    
    @IBAction func onReplyButtonTap(sender: AnyObject) {
        print("reply button tapped ... ")
        var userInfo : [String : AnyObject] = [:]
        userInfo["tweetCell"] = self
        print("reply button notification sent ... ")
        NSNotificationCenter.defaultCenter().postNotificationName("ReplyButtonTapped", object: nil, userInfo: userInfo)
    }
    
    @IBAction func onRetweetButtonTap(sender: AnyObject) {
        print("retweet button tapped ... ")
        var userInfo : [String : AnyObject] = [:]
        userInfo["tweetCell"] = self
        print("retweet button notification sent ... ")
        NSNotificationCenter.defaultCenter().postNotificationName("RetweetButtonTapped", object: nil, userInfo: userInfo)
        
    }

    @IBAction func onFavoriteButtonTap(sender: AnyObject)    {
        print("favorite button tapped ... ")
        var userInfo : [String : AnyObject] = [:]
        userInfo["tweetCell"] = self
        print("favorite button notification sent ... ")
        NSNotificationCenter.defaultCenter().postNotificationName("FavoriteButtonTapped", object: nil, userInfo: userInfo)
    }
}
