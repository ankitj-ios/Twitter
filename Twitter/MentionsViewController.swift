//
//  MentionsViewController.swift
//  Twitter
//
//  Created by Ankit Jasuja on 8/7/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController {
    
    
    @IBOutlet weak var mentionTweetsTableView: UITableView!
    
    var tweets : [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mentionTweetsTableView.dataSource = self
        self.mentionTweetsTableView.delegate = self
        
        let parameters : [String : String] = [:]
        TwitterClient.sharedInstance.fetchMentionsTimelineWithParams({ (tweets) in
            self.tweets = tweets
            self.mentionTweetsTableView.reloadData()
            }, failure: { (error : NSError) in
                print(error)
            }, parameters: parameters)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension MentionsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MentionsTweetCell") as! MentionsTweetCell
        let tweet = tweets[indexPath.row]
        populateMentionTweetCell(cell, tweet : tweet)
        return cell
    }
    
    func populateMentionTweetCell(cell : MentionsTweetCell, tweet : Tweet) -> Void {
        cell.tweet = tweet
        cell.tweetTextLabel.text = tweet.tweetText
        cell.replyButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cell.retweetCountLabel.text = String(tweet.retweetCount!)
        if tweet.isRetweeted {
            cell.retweetButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        } else {
            cell.retweetButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        cell.favoriteCountLabel.text = String(tweet.favouriteCount!)
        if tweet.isFavorited {
            cell.favoriteButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        } else {
            cell.favoriteButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        cell.userName.text = tweet.tweetUser?.userName
        cell.userScreenName.text = "@\(tweet.tweetUser!.userScreenName!)"
        cell.createdAtLabel.text = TwitterUtils.getStringFromDate(tweet.tweetCreatedDate!)
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
