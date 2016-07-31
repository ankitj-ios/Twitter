//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Ankit Jasuja on 7/30/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    @IBOutlet weak var tweetsTableView: UITableView!
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    var tweets : [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetsTableView.dataSource = self
        tweetsTableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        TwitterClient.sharedInstance.fetchHomeTimeline({ (tweets) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            }) { (error) in
            print("Error  : \(error.localizedDescription)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TweetsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tweetsTableView.dequeueReusableCellWithIdentifier(Constants.TWEET_CELL_IDENTIFIER) as! TweetCell
        let tweet = tweets[indexPath.row]
        populateTweetCell(cell, tweet: tweet)
        return cell
    }
    
    func populateTweetCell(cell : TweetCell, tweet : Tweet) -> Void {
        cell.tweetTextLabel.text = tweet.tweetText
        cell.retweetCountLabel.text = String(tweet.retweetCount!)
        cell.favoriteCountLabel.text = String(tweet.favouriteCount!)
        cell.userName.text = tweet.tweetUser?.userName
        cell.userScreenName.text = tweet.tweetUser?.userScreenName
        cell.createdAtLabel.text = "1/01/0001"
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
