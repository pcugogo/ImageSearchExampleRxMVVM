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
    func add(favoritesKey: String) {
        var newList = favorites
        newList.append(favoritesKey)
        UserDefaults.standard.set(newList, forKey: Key.favorites.rawValue)
    }
    func remove(favoritesKey: String) {
        let newList = favorites.filter { $0 != favoritesKey }
        UserDefaults.standard.set(newList, forKey: Key.favorites.rawValue)
    }
    func isAddedFavorites(favoritesKey: String) -> Bool {
        return favorites.contains(favoritesKey)
    }
    func updateFavorites(favoritesKey: String) -> IsDuplicate {
        if isAddedFavorites(favoritesKey: favoritesKey) {
            remove(favoritesKey: favoritesKey)
        } else {
            add(favoritesKey: favoritesKey)
        }
        return isAddedFavorites(favoritesKey: favoritesKey)
    }
}
