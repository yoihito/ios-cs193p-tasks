//
//  ImageTableViewCell.swift
//  TweetOrganizer
//
//  Created by Vadim Gribanov on 08/05/2017.
//  Copyright © 2017 Vadim Gribanov. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetImageView: UIImageView!
    
    var imageURL: URL? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let imageURL = imageURL {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                if let imageData = NSData(contentsOf: imageURL) as Data? {
                    DispatchQueue.main.async { [weak self] in
                        self?.tweetImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        }

    }

}
