//
//  ImageFavoritesStorageFake.swift
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
    func isAddedFavorite(forKey: String) -> Bool {
        return favorites.contains(forKey)
    }
    
    func updateFavorite(forKey: String) -> IsDuplicate {
        if isAddedFavorite(forKey: forKey) {
            remove(favoritesKey: forKey)
        } else {
            add(favoritesKey: forKey)
        }
        return isAddedFavorite(forKey: forKey)
    }
}
