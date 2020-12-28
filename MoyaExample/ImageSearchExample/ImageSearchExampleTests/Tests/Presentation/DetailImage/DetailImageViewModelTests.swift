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
import SCoordinator
import Nimble

@testable import ImageSearchExample

final class DetailImageModelTests: XCTestCase {
    var disposeBag = DisposeBag()
    var favoritesRepository: FavoritesRepository!
    var fatchFavoritesUseCase: FetchFavoritesUseCaseType!
    var viewModel: DetailImageViewModel!
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
        
        viewModel.output.imageURLString
            .asObservable()
            .subscribe(onNext: { imageURLString in
                XCTAssertFalse(imageURLString.isEmpty, "imageURLString is empty")
            })
            .disposed(by: disposeBag)
    }
    func test_FavoriteButtonAction() {
        
        viewModel.input.favoriteButtonAction.accept(Void())
        
        viewModel.output.isAddFavorites
            .drive(onNext: { isAddFavorites in
                XCTAssertTrue(isAddFavorites, "Update Favorite Error // - output value: \(isAddFavorites)")
            })
            .disposed(by: disposeBag)
    }
}

extension DetailImageModelTests {
    func configureViewModel() -> DetailImageViewModel {
        let coordinator = SearchCoordinator(
            rootView: .init(),
            parentCoordinator: RootCoordinator(rootView: UIViewController())
        )
        let viewModel = DetailImageViewModel(
            coordinator: coordinator,
            imageURLString: dummyData.imageURLString,
            fetchFavoritesUseCase: self.fatchFavoritesUseCase
        )
        return viewModel
    }
}
