//
//  TweetTableViewCell.swift
//  TweetOrganizer
//
//  Created by Vadim Gribanov on 07/05/2017.
//  Copyright © 2017 Vadim Gribanov. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        tweetScreenNameLabel.text = nil
        tweetProfileImageView.image = nil
        tweetCreatedLabel.text = nil
        tweetTextLabel.attributedText = nil
        
        if let tweet = self.tweet {
            var tweetText = tweet.text
            
            for _ in tweet.media {
                tweetText += " 📷"
            }
            
            let tweetAttributedText = NSMutableAttributedString(string: tweetText)
            
            for user in tweet.userMentions {
                tweetAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: user.nsrange)
            }
            
            for hashtag in tweet.hashtags {
                tweetAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.purple, range: hashtag.nsrange)
            }
            
            for url in tweet.urls {
                tweetAttributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: url.nsrange)
            }
            
            tweetTextLabel.attributedText = tweetAttributedText

            
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let profileImageURL = tweet.user.profileImageURL {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                    if let imageData = NSData(contentsOf: profileImageURL) as Data? {
                        DispatchQueue.main.async { [weak self] in
                            self?.tweetProfileImageView?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
            
            let formatter = DateFormatter()
            if Date().timeIntervalSince(tweet.created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel.text = formatter.string(from: tweet.created)
        }
    }

}
