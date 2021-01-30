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
import RxBlocking
import RxSwift
import RxCocoa
import SCoordinator

@testable import ImageSearchExample

final class SearchViewModelTests: XCTestCase {
    
    var disposeBag = DisposeBag()
    let apiServiceSpy = SearchAPIServiceSpy()
    var searchRepository: SearchRepositoryType!
    var searchUseCase: SearchUseCaseType!
    var viewModel: SearchViewModel!
    let scheduler = TestScheduler(initialClock: 0)
    
    override func setUp() {
        super.setUp()
        
        self.searchRepository = SearchRepository(apiService: apiServiceSpy)
        self.searchUseCase = SearchUseCase(imageSearchRepository: searchRepository)
        
        self.viewModel = configureViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
    }
    
    func test_SearchViewModel_searchAction() {
        // Given
        let imagesSectionsIsEmpty = scheduler.createObserver(Bool.self)
        
        viewModel.output.imagesSections
            .map { $0[0].items.isEmpty }
            .drive(imagesSectionsIsEmpty)
            .disposed(by: disposeBag)
         
        // When
        scheduler.createColdObservable([.next(1, ("test"))])
            .bind(to: viewModel.input.searchButtonAction)
            .disposed(by: disposeBag)
        scheduler.start()
        
        // Then
        let recordedEvents = Recorded.events(
            .next(0, true),
            .next(1, false)
        )
        XCTAssertEqual(imagesSectionsIsEmpty.events, recordedEvents)
    }
    
    func test_SearchViewModel_moreFetch() {
        // Given
        let searchImageDummy = SearchImageDummy()
        let imagesSectionsIsEmpty = scheduler.createObserver(Bool.self)
        
        viewModel.output.imagesSections
            .map { $0[0].items.isEmpty }
            .drive(imagesSectionsIsEmpty)
            .disposed(by: disposeBag)
         
        // When
        scheduler.createColdObservable([.next(1, ("test"))])
            .bind(to: viewModel.input.searchButtonAction)
            .disposed(by: disposeBag)
        scheduler.createColdObservable([.next(2, (IndexPath(item: searchImageDummy.totalCount - 1, section: 0)))])
            .bind(to: viewModel.input.willDisplayCell)
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

extension SearchViewModelTests {
    func configureViewModel() -> SearchViewModel {
        let coordinator = SearchCoordinator(
            rootView: UINavigationController(),
            parentCoordinator: RootCoordinator(rootView: UIViewController())
        )
        let viewModel = SearchViewModel(
            coordinator: coordinator,
            searchUseCase: searchUseCase
        )
        return viewModel
    }
}
