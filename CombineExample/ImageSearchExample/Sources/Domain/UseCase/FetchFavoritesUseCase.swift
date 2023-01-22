//
//  FetchFavoritesUseCase.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/16.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

protocol FetchFavoritesUseCaseType {
    typealias IsContains = Bool
    
    func isContains(_ favorite: String) -> IsContains
    @discardableResult
    func update(_ favorite: String) -> IsContains
}

struct FetchFavoritesUseCase: FetchFavoritesUseCaseType {
    
    private let favoritesRepository: FavoritesRepositoryType
    
    init(favoritesRepository: FavoritesRepositoryType = FavoritesRepository()) {
        self.favoritesRepository = favoritesRepository
    }
    
    func isContains(_ favorite: String) -> IsContains {
        return favoritesRepository.favorites.contains(favorite)
    }
    
    func update(_ favorite: String) -> IsContains {
        if isContains(favorite) {
            favoritesRepository.remove(favorite)
        } else {
            favoritesRepository.add(favorite)
        }
        return isContains(favorite)
    }
}
