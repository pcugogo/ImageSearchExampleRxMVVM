//
//  DetailImageViewModelTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 09/07/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import Nimble

@testable import ImageSearchExample

final class DetailImageModelTests: XCTestCase {
    var disposeBag = DisposeBag()
    var imageFavoritesStorage: ImageFavoritesStorageType!
    var viewModel: (DetailImageViewModel.Input, DetailImageViewModel.Output)!
    let dummyData = SearchImageDummy()
    
    override func setUp() {
        super.setUp()
        self.imageFavoritesStorage = ImageFavoritesStorageFake()
        self.viewModel = configureViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
        disposeBag = DisposeBag()
    }
    
    func test_ImageURLString() {
        viewModel.1.imageURLString
            .asObservable()
            .subscribe(onNext: { imageURLString in
                XCTAssertFalse(imageURLString.isEmpty, "imageURLString is empty")
            })
            .disposed(by: disposeBag)
    }
    func test_FavoriteButtonAction() {
        viewModel.1.isAddFavorites
            .drive(onNext: { isAddFavorites in
                XCTAssertTrue(isAddFavorites, "favoriteButton Action Error")
            })
            .disposed(by: disposeBag)
    }
}

extension DetailImageModelTests {
    func configureViewModel() -> (DetailImageViewModel.Input, DetailImageViewModel.Output) {
        let dependency = DetailImageCoordinator.Dependency(imageURLString: dummyData.imageURLString,
                                               imageFavoritesStorage: imageFavoritesStorage)
        let coordinator = DetailImageCoordinator(navigationController: UINavigationController())
        let viewModel = DetailImageViewModel(coordinator: coordinator, dependency: dependency)
        let favoriteButtonAction = BehaviorRelay(value: Void()).asDriver()
        
        let input = DetailImageViewModel.Input(favoriteButtonAction: favoriteButtonAction)
        return (input, viewModel.transform(input: input))
    }
}
