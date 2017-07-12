//
//  RecentQueriesTableViewController.swift
//  TweetOrganizer
//
//  Created by Vadim Gribanov on 08/05/2017.
//  Copyright © 2017 Vadim Gribanov. All rights reserved.
//

import UIKit

class RecentQueriesTableViewController: UITableViewController {

    let recentQueries = RecentQueries()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recentQueries.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QueryCell", for: indexPath)

        cell.textLabel?.text = recentQueries.get(indexPath.row)

        return cell
    }

    private struct Storyboard {
        static let TweetSearchSegue = "Tweet Search"
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            identifier == Storyboard.TweetSearchSegue,
            let nextScene = segue.destination as?  TweetTableViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            let query = recentQueries.get(indexPath.row)
            nextScene.searchText = query
        }
    }


}
