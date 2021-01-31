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

@testable import ImageSearchExample

final class DetailImageModelTests: XCTestCase {
    
    // MARK: - Propertys
    var disposeBag = DisposeBag()
    var favoritesRepository: FavoritesRepository!
    var fatchFavoritesUseCase: FetchFavoritesUseCaseType!
    var viewModel: DetailImageViewModel!
    let dummyData = SearchImageDummy()
    let scheduler = TestScheduler(initialClock: 0)
    
    // MARK: - Input
    let favoriteButtonAction: PublishRelay<Void> = .init()
    
    // MARK: - Output
    var output: DetailImageViewModel.Output!
    
    override func setUp() {
        super.setUp()
        
        self.favoritesRepository = FavoritesRepository(favoritesStorage: FavoritesStorageFake())
        self.fatchFavoritesUseCase = FetchFavoritesUseCase(favoritesRepository: favoritesRepository)
        self.viewModel = DetailImageViewModel(
            dependency: .init(
                imageURLString: dummyData.imageURLString,
                fetchFavoritesUseCase: fatchFavoritesUseCase
            )
        )
        
        let input = DetailImageViewModel.Input(favoriteButtonAction: favoriteButtonAction.asSignal())
        self.output = viewModel.transform(input: input)
    }
    
    func testImageURLString() {
        // Given
        let imageURLString = scheduler.createObserver(String.self)
        
        output.imageURLString
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
        
        output.isAddFavorites
            .drive(isAddFavorites)
            .disposed(by: disposeBag)
         
        // When
        scheduler.createColdObservable([.next(1, ())])
            .bind(to: favoriteButtonAction)
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
