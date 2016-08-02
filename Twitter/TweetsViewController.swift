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
        registerNotificationObservers()
    }
    
    func registerNotificationObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleReplyNotification),
            name: "ReplyButtonTapped", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleRetweetNotification), name: "RetweetButtonTapped", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleFavoriteNotification), name: "FavoriteButtonTapped", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.handleTweetNotification),
            name: "TweetButtonTapped", object: nil)
    }
    
    func handleTweetNotification(notification : NSNotification) {
        print("have to update table view with latest cell at index = 0")
        let userInfo : [NSObject : AnyObject] = notification.userInfo!
        let tweetString = userInfo["tweetText"] as? String
        var tweetDictionary : [String : String] = [:]
        tweetDictionary["text"] = tweetString
        let tweet = Tweet(tweetDictionary: tweetDictionary as NSDictionary)
        self.tweets.insert(tweet, atIndex: 0)
        self.tweetsTableView.reloadData()
    }
    
    func handleReplyNotification(notification : NSNotification) {
        let userInfo : [NSObject : AnyObject] = notification.userInfo!
        let tweetCell = userInfo["tweetCell"] as? TweetCell
        let tweet = tweetCell?.tweet
        print(tweetCell?.tweetTextLabel.text)
        print(tweet?.tweetIdString ?? "")
        print("retweet button notification received .... ")
        self.performSegueWithIdentifier("ReplyToComposeSegue", sender: tweet)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segue called ... ")
        let segueIdentifier = segue.identifier
        if let segueIdentifier = segueIdentifier {
            if segueIdentifier == "ReplyToComposeSegue" {
                let composeViewController = segue.destinationViewController as! ComposeViewController
                composeViewController.isReply = true
                let tweet = sender as! Tweet
                composeViewController.tweet = tweet
                composeViewController.isPlaceHolderPresent = false
                print("in segue for tweet user ... \(tweet.tweetUser?.userScreenName)")
            }
            if segueIdentifier == "CellToDetailSegue" {
                print("inside cell to detail segue ... ")
                let detailsViewController = segue.destinationViewController as! TweetDetailsViewController
                let cell = sender as! TweetCell
                detailsViewController.tweet = cell.tweet!
                detailsViewController.tweetCell = cell
            }
        }
    }

    func handleRetweetNotification(notification : NSNotification) {
        let userInfo : [NSObject : AnyObject] = notification.userInfo!
        let tweetCell = userInfo["tweetCell"] as? TweetCell
        var indexPaths : [NSIndexPath] = []
        indexPaths.append(tweetsTableView.indexPathForCell(tweetCell!)!)
        let tweet = tweetCell?.tweet
        print("retweet button notification received .... ")
        print(tweetCell?.tweetTextLabel.text)
        print(tweet?.tweetIdString ?? "")
        if let tweet = tweet {
            let isRetweeted = tweet.isRetweeted
            if let tweetIdString = tweet.tweetIdString {
                if isRetweeted {
                    TwitterClient.sharedInstance.unRetweet(tweetIdString)
                    tweet.retweetCount! -= 1
                    tweet.isRetweeted = false
                    tweetCell?.retweetButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
                } else {
                    TwitterClient.sharedInstance.retweet(tweetIdString)
                    tweet.retweetCount! += 1
                    tweet.isRetweeted = true
                    tweetCell?.retweetButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                }
                tweetsTableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            }
        }
    }
    
    func handleFavoriteNotification(notification : NSNotification) {
        let userInfo : [NSObject : AnyObject] = notification.userInfo!
        let tweetCell = userInfo["tweetCell"] as? TweetCell
        var indexPaths : [NSIndexPath] = []
        indexPaths.append(tweetsTableView.indexPathForCell(tweetCell!)!)
        let tweet = tweetCell?.tweet
        print("favorite button notification received .... ")
        if let tweet = tweet {
            let isFavorited = tweet.isFavorited
            if let tweetIdString = tweet.tweetIdString {
                print("tweetId : \(tweetIdString)")
                if isFavorited {
                    TwitterClient.sharedInstance.unfavorite(tweetIdString)
                    tweet.favouriteCount! -= 1
                    tweet.isFavorited = false
                    tweetCell?.favoriteButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                } else {
                    TwitterClient.sharedInstance.favorite(tweetIdString)
                    tweet.favouriteCount! += 1
                    tweet.isFavorited = true
                    tweetCell?.favoriteButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                }
                tweetsTableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func getStringFromDate(date : NSDate) -> String {
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return dateformatter.stringFromDate(date)
    }
    
    func populateTweetCell(cell : TweetCell, tweet : Tweet) -> Void {
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
        cell.createdAtLabel.text = getStringFromDate(tweet.tweetCreatedDate!)
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