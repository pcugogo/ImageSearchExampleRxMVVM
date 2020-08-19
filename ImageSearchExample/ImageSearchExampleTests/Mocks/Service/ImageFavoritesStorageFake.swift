//
//  LocalStorageFake.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 09/07/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

@testable import ImageSearchExample

final class ImageFavoritesStorageFake: ImageFavoritesStorageType {
    var userDefaultsFavorites: [String] = .init()
    
    var favorites: [String] {
        return userDefaultsFavorites
    }
    
    func add(favoritesKey: String) {
        userDefaultsFavorites.append(favoritesKey)
    }
    
    func remove(favoritesKey: String) {
        let newFavorites = userDefaultsFavorites.filter { $0 != favoritesKey }
        userDefaultsFavorites = newFavorites
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
