//
//  ImageFavoritesStorageType.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 05/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

protocol FavoritesStorageType {
    
    var favorites: [String] { get }
    func add(_ favorite: String)
    func remove(_ favorite: String)
}
