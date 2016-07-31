//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Ankit Jasuja on 7/30/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

let placeHolderText = "What's happening ?"
let tweetMaxCharacterCount : Int = 140

class ComposeViewController: UIViewController {

    @IBOutlet weak var composeScrollView: UIScrollView!
    
    @IBOutlet weak var tweetTextView: UITextView!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    
    @IBOutlet weak var remainingCountLabel: UILabel!
    
    
    @IBOutlet weak var tweetButton: UIButton!
    
    var isPlaceHolderPresent = true
    
    @IBAction func onTweetButtonTap(sender: AnyObject) {
        let tweetText = self.tweetTextView.text
        TwitterClient.sharedInstance.postTweet(tweetText)
    }
    
    @IBAction func onCancelButtonTap(sender:AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func applyTextViewPlaceholderStyle(textView : UITextView, placeHolderText : String) {
        textView.textColor = UIColor.lightGrayColor()
        textView.text = placeHolderText
    }
    
    func removePlaceholderStyle(textView: UITextView) {
        textView.textColor = UIColor.darkTextColor()
        textView.alpha = 1.0
        textView.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetButton.enabled = false
        
        tweetTextView.delegate = self
        
        applyTextViewPlaceholderStyle(
            self.tweetTextView, placeHolderText: placeHolderText)
        
        remainingCountLabel.text = "140"
        
        if let userProfileImageUrl = User.currentUser!.profileImageUrl {
            let userProfileImageRequest = NSURLRequest(URL: userProfileImageUrl)
            userProfileImageView.setImageWithURLRequest(userProfileImageRequest, placeholderImage: nil, success: { (userProfileImageRequest, userProfileImageResponse, userProfileImage) in
                self.userProfileImageView.image = userProfileImage
            }) { (userProfileImageRequest, userProfileImageResponse, error) in
                print(error)
            }
        }

    }
    
}

extension ComposeViewController : UITextViewDelegate {
    
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text == placeHolderText {
            moveCursorToStart(textView)
        }
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let currentCharactersCount  = textView.text.characters.count
        let remainingCount = tweetMaxCharacterCount - currentCharactersCount
        if currentCharactersCount == 0 {
            print("current count is zero ... ")
            applyTextViewPlaceholderStyle(textView, placeHolderText: placeHolderText)
            moveCursorToStart(textView)
            isPlaceHolderPresent = true
            tweetButton.enabled = false
        } else if isPlaceHolderPresent {
            isPlaceHolderPresent = false
            removePlaceholderStyle(textView)
            tweetButton.enabled = true
        }
        
        if remainingCount < 0 {
            tweetButton.enabled = false
        } else {
            tweetButton.enabled = true
            if remainingCount < 20 {
                self.remainingCountLabel.textColor = UIColor.redColor()
            } else {
                self.remainingCountLabel.textColor = UIColor.grayColor()
            }
        }
        self.remainingCountLabel.text = String(remainingCount)
        return true
    }
    
    func moveCursorToStart(textView: UITextView)
    {
        dispatch_async(dispatch_get_main_queue(), {
            textView.selectedRange = NSMakeRange(0, 0);
        })
    }
}
