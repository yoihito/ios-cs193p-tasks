//
//  TweetDetailTableViewController.swift
//  TweetOrganizer
//
//  Created by Vadim Gribanov on 08/05/2017.
//  Copyright © 2017 Vadim Gribanov. All rights reserved.
//

import UIKit
import Twitter

class TweetDetailsTableViewController: UITableViewController {

    private var sections = [Section]()
    
    private struct SectionTitles {
        static let images = "Images"
        static let hashtags = "Hashtags"
        static let userMentions = "Users"
        static let URLs = "Links"
    }
    
    var tweet: Twitter.Tweet? {
        didSet {
            sections.removeAll()
            if let media = tweet?.media, !media.isEmpty {
                sections.append(Section(
                    title: SectionTitles.images,
                    items: media.map {
                        .Image($0.url, $0.aspectRatio)
                    }
                ))
            }
            
            if let hashtags = tweet?.hashtags, !hashtags.isEmpty {
                sections.append(Section(
                    title: SectionTitles.hashtags,
                    items: hashtags.map {
                        .Mention($0.keyword)
                    }
                ))
            }
            
            if let userMentions = tweet?.userMentions, !userMentions.isEmpty {
                sections.append(Section(
                    title: SectionTitles.userMentions,
                    items: userMentions.map {
                        .Mention($0.keyword)
                    }
                ))
            }
            
            if let URLs = tweet?.urls, !URLs.isEmpty {
                sections.append(Section(
                    title: SectionTitles.URLs,
                    items: URLs.map {
                        .URL($0.keyword)
                    }
                ))
            }
            
        }
    }
    
    private struct Section {
        var title: String?
        var items: [SectionItem]
    }
    
    private enum SectionItem {
        case Mention(String)
        case URL(String)
        case Image(URL, Double)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    private struct Storyboard {
        static let MentionCell = "Mention Cell"
        static let ImageCell = "Image Cell"
        static let TweetSearchSegue = "Tweet Search"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionItem = sections[indexPath.section].items[indexPath.row]
        
        switch sectionItem {
        case .Mention(let mention), .URL(let mention):
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MentionCell, for: indexPath)
            cell.textLabel?.text = mention
            
            return cell
                    
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.ImageCell, for: indexPath)
            if let imageCell = cell as? ImageTableViewCell {
                imageCell.imageURL = url
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionItem = sections[indexPath.section].items[indexPath.row]
        
        switch sectionItem {
        case .Image(_, let aspectRatio):
            let height = tableView.bounds.width / CGFloat(aspectRatio)
            return height
        default:
            return UITableViewAutomaticDimension
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            identifier == Storyboard.TweetSearchSegue,
            let nextScene = segue.destination as? TweetTableViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            let sectionItem = sections[indexPath.section].items[indexPath.row]
            
            switch sectionItem {
            case .Mention(let mention):
                nextScene.searchText = mention
            default:
                return
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Storyboard.TweetSearchSegue,
            let indexPath = tableView.indexPathForSelectedRow {
            let sectionItem = sections[indexPath.section].items[indexPath.row]
            switch sectionItem {
            case .URL(let url):
                UIApplication.shared.open(URL(string: url)!)
                return false
            default:
                return true
            }
        }
        return true
    }
 

}
