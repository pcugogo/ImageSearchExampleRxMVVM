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
    var favoritesRepository: FavoritesRepository!
    var fatchFavoritesUseCase: FetchFavoritesUseCaseType!
    var viewModel: (DetailImageViewModel.Input, DetailImageViewModel.Output)!
    let dummyData = SearchImageDummy()
    
    override func setUp() {
        super.setUp()
        
        self.favoritesRepository = FavoritesRepository(favoritesStorage: FavoritesStorageFake())
        self.fatchFavoritesUseCase = FetchFavoritesUseCase(favoritesRepository: favoritesRepository)
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
        let dependency = DetailImageViewModel.Dependency(
            imageURLString: dummyData.imageURLString,
            fetchFavoritesUseCase: fatchFavoritesUseCase
        )
        let viewModel = DetailImageViewModel(dependency: dependency)
        let favoriteButtonAction = BehaviorRelay(value: Void()).asDriver()
        
        let input = DetailImageViewModel.Input(favoriteButtonAction: favoriteButtonAction)
        return (input, viewModel.transform(input: input))
    }
}
