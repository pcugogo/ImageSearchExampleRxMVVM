//
//  FetchFavoritesUseCaseTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 2020/12/27.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import XCTest
import Nimble
import RxTest
import RxSwift
import RxCocoa

@testable import ImageSearchExample

final class FetchFavoritesUseCaseTests: XCTestCase {
    var disposeBag = DisposeBag()
    let favoritesStorage = FavoritesStorageFake()
    var favoritesRepository: FavoritesRepositoryType!
    var fetchFavoritesUseCase: FetchFavoritesUseCaseType!
    
    override func setUp() {
        super.setUp()
        self.favoritesRepository = FavoritesRepository(favoritesStorage: favoritesStorage)
        self.fetchFavoritesUseCase = FetchFavoritesUseCase(favoritesRepository: favoritesRepository)
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
        disposeBag = DisposeBag()
    }
    
    func testUpdateFavorites() {
        
        let testFavorite = "TestFavorite"
        fetchFavoritesUseCase.update(testFavorite)
        XCTAssertTrue(fetchFavoritesUseCase.isContains(testFavorite), "Duplicate Check Error")
        fetchFavoritesUseCase.update(testFavorite)
        XCTAssertFalse(fetchFavoritesUseCase.isContains(testFavorite), "Added Favorites Check Error")
    }
}
