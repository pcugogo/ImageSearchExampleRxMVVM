//
//  FavoritesRepository.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2021/01/18.
//  Copyright © 2021 ChanWookPark. All rights reserved.
//

import Foundation

struct FavoritesRepository {
    
    private let favoritesStorage: FavoritesStorageType
    
    init(favoritesStorage: FavoritesStorageType = FavoritesStorage()) {
        self.favoritesStorage = favoritesStorage
    }
}

extension FavoritesRepository: FavoritesRepositoryType {
    var favorites: [String] {
        return favoritesStorage.favorites
    }
    
    func add(_ favorite: String) {
        return favoritesStorage.add(favorite)
    }
    
    func remove(_ favorite: String) {
        return favoritesStorage.remove(favorite)
    }
}
