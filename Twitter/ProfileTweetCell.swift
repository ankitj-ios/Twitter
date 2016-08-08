//
//  ProfileTweetCell.swift
//  Twitter
//
//  Created by Ankit Jasuja on 8/8/16.
//  Copyright © 2016 Ankit Jasuja. All rights reserved.
//

import UIKit

class ProfileTweetCell: UITableViewCell {

    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var userScreenName: UILabel!
    
    @IBOutlet weak var createdAt: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var retweetCount: UILabel!
    
    @IBOutlet weak var favoriteCount: UILabel!
    
    
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var retweetButton: UIButton!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet : Tweet?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
