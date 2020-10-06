//
//  ImageFavoritesStorage.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 07/06/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

struct ImageFavoritesStorage: ImageFavoritesStorageType {
    private enum Key: String {
        case favorites
    }
    var favorites: [String] {
        guard let list = UserDefaults.standard.array(forKey: Key.favorites.rawValue) as? [String] else { return [] }
        return list
    }
    func add(_ favorite: String) {
        var newList = favorites
        newList.append(favorite)
        UserDefaults.standard.set(newList, forKey: Key.favorites.rawValue)
    }
    func remove(_ favorite: String) {
        let newList = favorites.filter { $0 != favorite }
        UserDefaults.standard.set(newList, forKey: Key.favorites.rawValue)
    }
    func isContains(_ favorite: String) -> Bool {
        return favorites.contains(favorite)
    }
    func update(_ favorite: String) -> IsDuplicate {
        if isContains(favorite) {
            remove(favorite)
        } else {
            add(favorite)
        }
        return isContains(favorite)
    }
}
