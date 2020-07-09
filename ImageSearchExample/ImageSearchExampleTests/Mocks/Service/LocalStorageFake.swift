//
//  LocalStorageFake.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 09/07/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

@testable import ImageSearchExample

final class LocalStorageFake: LocalStorageType {
    var userDefaultsFavorites: [String] = .init()
    
    var favorites: [String] {
        return userDefaultsFavorites
    }
    
    func add(favorite: String) {
        userDefaultsFavorites.append(favorite)
    }
    
    func remove(favorite: String) {
        let newFavorites = userDefaultsFavorites.filter { $0 != favorite }
        userDefaultsFavorites = newFavorites
    }
}
