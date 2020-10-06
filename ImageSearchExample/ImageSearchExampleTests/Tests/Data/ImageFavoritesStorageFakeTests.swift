//
//  ImageFavoritesStorageFakeTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 2020/10/06.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import ImageSearchExample

final class ImageFavoritesStorageFakeTests: XCTestCase {
    var disposeBag = DisposeBag()
    var imageFavoritesStorage: ImageFavoritesStorageType!

    override func setUp() {
        super.setUp()
        self.imageFavoritesStorage = ImageFavoritesStorageFake()
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
        disposeBag = DisposeBag()
    }
    
    func test_UpdateFavorites() {
        let testFavorite = "TestFavorite"
        imageFavoritesStorage.update(testFavorite)
        XCTAssertTrue(imageFavoritesStorage.isContains(testFavorite), "Duplicate Check Error")
        imageFavoritesStorage.update(testFavorite)
        XCTAssertFalse(imageFavoritesStorage.isContains(testFavorite), "Added Favorites Check Error")
    }
}
