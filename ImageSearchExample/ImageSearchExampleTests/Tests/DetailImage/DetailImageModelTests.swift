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

@testable import ImageSearchExample

final class DetailImageModelTests: XCTestCase {
    var disposeBag = DisposeBag()
    var localStorage: LocalStorageType!
    var model: DetailImageModelType!
    var viewModel: DetailImageViewModel!
    
    override func setUp() {
        super.setUp()
        let dummyData = SearchImageDummy()
        self.localStorage = LocalStorageFake()
        self.model = DetailImageModel(localStorage: localStorage, imageURLString: dummyData.imageURLString)
        self.viewModel = DetailImageViewModel(model: self.model)
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
    }
    
    // Model Tests
    func testUpdateFavorites() {
        _ = model.updateFavorites()
        XCTAssertTrue(model.isAddedFavorites(), "Duplicate Check Error")
        _ = model.updateFavorites()
        XCTAssertFalse(model.isAddedFavorites(), "Added Favorites Check Error")
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
            .subscribe(onNext: { isAddFavorites in
                XCTAssertTrue(isAddFavorites, "favoriteButton Action Error")
            })
            .disposed(by: disposeBag)
    }
}
