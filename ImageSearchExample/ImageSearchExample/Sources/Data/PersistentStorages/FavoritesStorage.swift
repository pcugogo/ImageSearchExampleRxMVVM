//
//  ImageFavoritesStorage.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 07/06/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

struct FavoritesStorage: FavoritesStorageType {
    
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
}
