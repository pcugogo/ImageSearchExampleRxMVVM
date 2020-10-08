//
//  ImageFavoritesStorageType.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 05/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

protocol ImageFavoritesStorageType {
    typealias IsContains = Bool
    
    var favorites: [String] { get }
    func add(_ favorite: String)
    func remove(_ favorite: String)
    func isContains(_ favorite: String) -> Bool
    @discardableResult
    func update(_ favorite: String) -> IsContains
}
