//
//  SearchViewModelTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import XCTest
import Nimble
import RxTest
import RxSwift
import RxCocoa

@testable import ImageSearchExample

final class SearchViewModelTests: XCTestCase {
    
    // MARK: - Propertys
    var disposeBag = DisposeBag()
    let apiServiceSpy = SearchAPIServiceSpy()
    var searchUseCase: SearchUseCaseType!
    var viewModel: SearchViewModel!
    let scheduler = TestScheduler(initialClock: 0)
    
    // MARK: - Input
    let searchAction = PublishRelay<String>()
    let willDisplayCell = PublishRelay<IndexPath>()
    let itemSeletedAction = PublishRelay<IndexPath>()
    
    // MARK: - Output
    var output: SearchViewModel.Output!
    
    override func setUp() {
        super.setUp()
        
        self.searchUseCase = SearchUseCase(apiService: apiServiceSpy)
        viewModel = SearchViewModel(dependency: .init(searchUseCase: searchUseCase))
        
        let input = SearchViewModel.Input(
            searchAction: searchAction.asSignal(),
            willDisplayCell: willDisplayCell.asSignal(),
            itemSeletedAction: itemSeletedAction.asSignal()
        )
        self.output = viewModel.transform(input: input)
    }
    
    func testFetchSearchData() {
        // Given
        let searchImageDummy = SearchImageDummy()
        let imagesSectionsIsEmpty = scheduler.createObserver(Bool.self)
        
        output.imagesSections
            .map { $0[0].items.isEmpty }
            .drive(imagesSectionsIsEmpty)
            .disposed(by: disposeBag)
         
        // When
        scheduler.createColdObservable([.next(1, ("test"))])
            .bind(to: searchAction)
            .disposed(by: disposeBag)
        scheduler.createColdObservable([.next(2, (IndexPath(item: searchImageDummy.totalCount - 1, section: 0)))])
            .bind(to: willDisplayCell)
            .disposed(by: disposeBag)
        scheduler.start()
        
        // Then
        let recordedEvents = Recorded.events(
            .next(0, true),
            .next(1, false),
            .next(2, false)
        )
        XCTAssertEqual(imagesSectionsIsEmpty.events, recordedEvents)
    }
}
