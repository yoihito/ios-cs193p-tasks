//
//  RecentQueries.swift
//  TweetOrganizer
//
//  Created by Vadim Gribanov on 11/05/2017.
//  Copyright © 2017 Vadim Gribanov. All rights reserved.
//

import UIKit
import Foundation

class RecentQueries {
    
    private static let userDefaults = UserDefaults.standard
    
    private func get() -> Array<String> {
        return RecentQueries.userDefaults.stringArray(forKey: "recentQueries") ?? []
    }
    
    func get(_ index: Int) -> String {
        return  get()[index]
    }
    
    func add(_ query: String) {
        var recentQueries = self.get()
        recentQueries.insert(query, at: 0)
        while recentQueries.count > 100 {
            _ = recentQueries.dropFirst()
        }
        RecentQueries.userDefaults.set(recentQueries, forKey: "recentQueries")
    }
    
    func count() -> Int {
        return get().count
    }
    
}
