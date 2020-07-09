//
//  DetailImageModel.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 22/06/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

protocol DetailImageModelType {
    typealias IsDuplicate = Bool
    
    var localStorage: LocalStorageType { get }
    var imageURLString: String { get }
    
    func isAddedFavorites() -> Bool
    func updateFavorites() -> IsDuplicate
}

struct DetailImageModel: DetailImageModelType {
    let localStorage: LocalStorageType
    let imageURLString: String
    
    init(localStorage: LocalStorageType = LocalStorage(), imageURLString: String) {
        self.localStorage = localStorage
        self.imageURLString = imageURLString
    }
    
    func isAddedFavorites() -> Bool {
        return localStorage.favorites.contains(imageURLString)
    }
    func updateFavorites() -> IsDuplicate {
        if isAddedFavorites() {
            localStorage.remove(favorite: imageURLString)
        } else {
            localStorage.add(favorite: imageURLString)
        }
        return isAddedFavorites()
    }
}
