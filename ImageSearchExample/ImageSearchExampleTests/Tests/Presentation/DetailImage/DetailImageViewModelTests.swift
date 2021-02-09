//
//  DetailImageViewModelTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 09/07/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import XCTest
import Nimble
import RxTest
import RxSwift
import RxCocoa
import SCoordinator

@testable import ImageSearchExample

final class DetailImageModelTests: XCTestCase {
    var disposeBag = DisposeBag()
    var favoritesRepository: FavoritesRepository!
    var fatchFavoritesUseCase: FetchFavoritesUseCaseType!
    var viewModel: DetailImageViewModel!
    let dummyData = SearchImageDummy()
    let scheduler = TestScheduler(initialClock: 0)
    
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
        // Given
        let imageURLString = scheduler.createObserver(String.self)
        
        viewModel.output.imageURLString
            .emit(to: imageURLString)
            .disposed(by: disposeBag)
         
        // When
        scheduler.start()
        
        // Then
        let recordedEvents = Recorded.events(
            .next(0, dummyData.imageURLString),
            .completed(0)
        )
        XCTAssertEqual(imageURLString.events, recordedEvents)
    }
    
    func testFavoriteButtonAction() {
        // Given
        let isAddFavorites = scheduler.createObserver(Bool.self)
        
        viewModel.output.isAddFavorites
            .drive(isAddFavorites)
            .disposed(by: disposeBag)
         
        // When
        scheduler.createColdObservable([.next(1, ())])
            .bind(to: viewModel.input.favoriteButtonAction)
            .disposed(by: disposeBag)
        scheduler.start()
        
        // Then
        let recordedEvents = Recorded.events(
            .next(0, false),
            .next(1, true)
        )
        XCTAssertEqual(isAddFavorites.events, recordedEvents)
    }
}

extension DetailImageModelTests {
    func configureViewModel() -> DetailImageViewModel {
        let coordinator = SearchCoordinator(rootView: .init())
        let viewModel = DetailImageViewModel(
            coordinator: coordinator,
            imageURLString: dummyData.imageURLString,
            fetchFavoritesUseCase: self.fatchFavoritesUseCase
        )
        return viewModel
    }
}
