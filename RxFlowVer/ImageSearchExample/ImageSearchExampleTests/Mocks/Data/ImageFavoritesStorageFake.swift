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
    private var userDefaultsFavorites: [String] = .init()

    var favorites: [String] {
        return userDefaultsFavorites
    }
    
    func add(_ favorite: String) {
        userDefaultsFavorites.append(favorite)
    }
    
    func remove(_ favorite: String) {
        let newFavorites = userDefaultsFavorites.filter { $0 != favorite }
        userDefaultsFavorites = newFavorites
    }
    func isContains(_ favorite: String) -> Bool {
        return favorites.contains(favorite)
    }
    
    func update(_ favorite: String) -> IsContains {
        if isContains(favorite) {
            remove(favorite)
        } else {
            add(favorite)
        }
        return isContains(favorite)
    }
}
