//
//  FavoritesRepositoryType.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2021/01/18.
//  Copyright © 2021 ChanWookPark. All rights reserved.
//

import Foundation

protocol FavoritesRepositoryType {
    var favorites: [String] { get }
    func add(_ favorite: String)
    func remove(_ favorite: String)
}
