//
//  DetailImageModel.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 22/06/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//
import Foundation

struct DetailImageModel {
    typealias IsDuplicate = Bool
    let localStorage: LocalStorage
    
    init(localStorage: LocalStorage = LocalStorage()) {
        self.localStorage = localStorage
    }
    
    func updateFavorites(url: String) -> IsDuplicate {
        let duplicateFavorites = localStorage.favorites.filter {$0 == url}
        if duplicateFavorites.isEmpty {
            localStorage.add(favorite: url)
        } else {
            localStorage.remove(favorite: url)
        }
        return duplicateFavorites.isEmpty
    }
    func isAddedFavorites(url: String) -> Bool {
        return !localStorage.favorites.filter { $0 == url }.isEmpty
    }
}
