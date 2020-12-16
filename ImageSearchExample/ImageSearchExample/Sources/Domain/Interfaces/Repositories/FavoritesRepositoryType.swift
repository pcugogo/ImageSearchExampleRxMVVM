//
//  FavoritesRepositoryType.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/16.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

protocol FavoritesRepositoryType {
    var favorites: [String] { get }
    func add(_ favorite: String)
    func remove(_ favorite: String)
}
