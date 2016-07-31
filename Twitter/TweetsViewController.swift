//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Ankit Jasuja on 7/30/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var count = 20
    var isMoreDataLoading = false
    
    @IBOutlet weak var tweetsTableView: UITableView!
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    var tweets : [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tweetsTableView.insertSubview(refreshControl, atIndex: 0)
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
    
    func refreshControlAction(refreshControl : UIRefreshControl) {
        TwitterClient.sharedInstance.fetchHomeTimeline({ (tweets) in
            self.tweets = tweets
            self.tweetsTableView.reloadData()
            refreshControl.endRefreshing()
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

extension TweetsViewController : UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tweetsTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tweetsTableView.bounds.size.height
            var parameters : [String : String] = [:]
            parameters["count"] = String(count)
            if(scrollView.contentOffset.y >= scrollOffsetThreshold && tweetsTableView.dragging) {
                isMoreDataLoading = true
                TwitterClient.sharedInstance.fetchHomeTimelineWithParams({ (tweets) in
                    self.tweets = tweets
                    self.tweetsTableView.reloadData()
                    self.isMoreDataLoading = false
                    self.count += 20
                    }, failure: { (error) in
                        self.isMoreDataLoading = false
                        print("Error  : \(error.localizedDescription)")
                    }, parameters: parameters)
            }
        }
    }
}