//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Ankit Jasuja on 8/7/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var timelineImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var tweetsCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var friendsCountLabel: UILabel!
    
    @IBOutlet weak var profileTweetsTableView: UITableView!
    
    var tweets : [Tweet] = []
    var user : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.profileTweetsTableView.dataSource = self
        
        if user == nil {
            user = User.currentUser
        }
        populateUserHeader()
        var params : [String : String] = [:]
        params["user_id"] = String(user.userId!)
        TwitterClient.sharedInstance.fetchUserTimelineWithParams({ (tweets) in
            self.tweets = tweets
            print("user profile fetch successfully for user \(self.user.userScreenName!)" )
            self.profileTweetsTableView.reloadData()
            }, failure: { (error : NSError) in
                print(error)
            }, parameters: params)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateUserHeader() {
        if let userTimelineImageUrl = user.timelineImageUrl {
            let userTimelineImageRequest = NSURLRequest(URL: userTimelineImageUrl)
            timelineImageView.setImageWithURLRequest(userTimelineImageRequest, placeholderImage: nil, success: { (userProfileImageRequest, userTimelineImageResponse, userTimelineImage) in
                self.timelineImageView.image = userTimelineImage
            }) { (userTimelineImageRequest, userTimelineImageResponse, error) in
                print(error)
            }
        }
        if let userProfileImageUrl = user.profileImageUrl {
            let userProfileImageRequest = NSURLRequest(URL: userProfileImageUrl)
            profileImageView.setImageWithURLRequest(userProfileImageRequest, placeholderImage: nil, success: { (userProfileImageRequest, userProfileImageResponse, userProfileImage) in
                self.profileImageView.image = userProfileImage
            }) { (userProfileImageRequest, userProfileImageResponse, error) in
                print(error)
            }
        }
        userNameLabel.text = user.userName
        userScreenNameLabel.text = user.userScreenName
        followersCountLabel.text = String(user.followersCount)
        friendsCountLabel.text = String(user.friendsCount)
        tweetsCountLabel.text = String(user.tweetsCount)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ProfileViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let profileTweetCell = profileTweetsTableView.dequeueReusableCellWithIdentifier("ProfileTweetCell") as! ProfileTweetCell
        let tweet = tweets[indexPath.row]
        populateProfileTweetCell(profileTweetCell, tweet: tweet)
        return profileTweetCell
    }
    
    func populateProfileTweetCell(cell : ProfileTweetCell, tweet : Tweet) -> Void {
        cell.tweet = tweet
        cell.tweetTextLabel.text = tweet.tweetText
        cell.replyButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cell.retweetCount.text = String(tweet.retweetCount!)
        if tweet.isRetweeted {
            cell.retweetButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        } else {
            cell.retweetButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        cell.favoriteCount.text = String(tweet.favouriteCount!)
        if tweet.isFavorited {
            cell.favoriteButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        } else {
            cell.favoriteButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        cell.userName.text = tweet.tweetUser?.userName
        cell.userScreenName.text = "@\(tweet.tweetUser!.userScreenName!)"
        cell.createdAt.text = TwitterUtils.getStringFromDate(tweet.tweetCreatedDate!)
        if let userProfileImageUrl = tweet.tweetUser?.profileImageUrl {
            let userProfileImageRequest = NSURLRequest(URL: userProfileImageUrl)
            cell.userImageView.setImageWithURLRequest(userProfileImageRequest, placeholderImage: nil, success: { (userProfileImageRequest, userProfileImageResponse, userProfileImage) in
                cell.userImageView.image = userProfileImage
            }) { (userProfileImageRequest, userProfileImageResponse, error) in
                print(error)
            }
        }
    }

    
}