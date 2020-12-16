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
    func update(_ favorite: String) -> IsContains
}

struct FetchFavoritesUseCase: FetchFavoritesUseCaseType {
    
    private let imageFavoritesRepository: FavoritesRepositoryType
    
    init(imageFavoritesRepository: FavoritesRepositoryType = FavoritesRepository()) {
        self.imageFavoritesRepository = imageFavoritesRepository
    }
    
    func isContains(_ favorite: String) -> IsContains {
        return imageFavoritesRepository.favorites.contains(favorite)
    }
    
    @discardableResult
    func update(_ favorite: String) -> IsContains {
        if isContains(favorite) {
            imageFavoritesRepository.remove(favorite)
        } else {
            imageFavoritesRepository.add(favorite)
        }
        return isContains(favorite)
    }
}
