//
//  LocalStorage.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 07/06/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

struct LocalStorage {
    struct Key {
        static let favorites = "favorites"
    }
    var favorites: [String] {
        guard let likeList = UserDefaults.standard.array(forKey: Key.favorites) as? [String] else { return [] }
        return likeList
    }
    func add(favorite: String) {
        var newList = favorites
        newList.append(favorite)
        UserDefaults.standard.set(newList, forKey: Key.favorites)
    }
    func remove(favorite: String) {
        let newList = favorites.filter {$0 != favorite}
        UserDefaults.standard.set(newList, forKey: Key.favorites)
    }
}
