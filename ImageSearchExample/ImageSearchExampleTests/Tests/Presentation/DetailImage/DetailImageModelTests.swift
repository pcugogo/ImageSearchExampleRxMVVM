//
//  DetailImageModelTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 09/07/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
import Nimble

@testable import ImageSearchExample

final class DetailImageModelTests: XCTestCase {
    var disposeBag = DisposeBag()
    var imageFavoritesStorage: ImageFavoritesStorageType!
    var viewModel: DetailImageViewModel!
    let dummyData = SearchImageDummy()
    
    override func setUp() {
        super.setUp()
        self.imageFavoritesStorage = ImageFavoritesStorageFake()
        self.viewModel = DetailImageViewModel(imageFavoritesStorage: imageFavoritesStorage, imageURLString: dummyData.imageURLString)
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
        disposeBag = DisposeBag()
    }
    
    // Model Tests
    func testUpdateFavorites() {
        _ = imageFavoritesStorage.updateFavorites(forKey: dummyData.imageURLString)
        XCTAssertTrue(imageFavoritesStorage.isAddedFavorite(forKey: dummyData.imageURLString), "Duplicate Check Error")
        _ = imageFavoritesStorage.updateFavorites(forKey: dummyData.imageURLString)
        XCTAssertFalse(imageFavoritesStorage.isAddedFavorite(forKey: dummyData.imageURLString), "Added Favorites Check Error")
    }
    
    // ViewModel Tests
    func testImageURLString() {
        viewModel.outputs.imageURLString
            .subscribe(onNext: { imageURLString in
                XCTAssertFalse(imageURLString.isEmpty, "imageURLString is empty")
            })
            .disposed(by: disposeBag)
    }
    func testFavoriteButtonAction() {
        viewModel.inputs.favoriteButtonAction.accept(Void())
        viewModel.outputs.isAddFavorites
            .drive(onNext: { isAddFavorites in
                XCTAssertTrue(isAddFavorites, "favoriteButton Action Error")
            })
            .disposed(by: disposeBag)
    }
}
