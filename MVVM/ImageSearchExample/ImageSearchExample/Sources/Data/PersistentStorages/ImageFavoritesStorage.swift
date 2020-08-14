//
//  ImageFavoritesStorage.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 05/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

protocol ImageFavoritesStorage {
    typealias IsDuplicate = Bool
    
    var favorites: [String] { get }
    func add(favoritesKey: String)
    func remove(favoritesKey: String)
    func isAddedFavorites(favoritesKey: String) -> Bool
    func updateFavorites(favoritesKey: String) -> IsDuplicate
}
