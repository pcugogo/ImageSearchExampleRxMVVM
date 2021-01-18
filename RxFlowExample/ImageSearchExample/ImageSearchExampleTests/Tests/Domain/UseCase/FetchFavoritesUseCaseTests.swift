//
//  FetchFavoritesUseCaseTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 2021/01/18.
//  Copyright © 2021 ChanWookPark. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
import Nimble

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
