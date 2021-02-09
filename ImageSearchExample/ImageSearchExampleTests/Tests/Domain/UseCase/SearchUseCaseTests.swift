//
//  SearchUseCaseTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 13/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import XCTest
import Nimble
import RxTest
import RxSwift
import RxCocoa

@testable import ImageSearchExample

final class SearchUseCaseTests: XCTestCase {
    var disposeBag = DisposeBag()
    let apiServiceSpy: SearchAPIServiceSpyType = SearchAPIServiceSpy()
    var searchRepository: SearchRepositoryType!
    var searchUseCase: SearchUseCaseType!
    let scheduler = TestScheduler(initialClock: 0)
    
    override func setUp() {
        super.setUp()
        searchRepository = SearchRepository(apiService: apiServiceSpy)
        self.searchUseCase = SearchUseCase(imageSearchRepository: searchRepository)
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
    }

    func testSearchImage() {
        // Given
        let currentPage = scheduler.createObserver(Int.self)
        
        apiServiceSpy.page
            .bind(to: currentPage)
            .disposed(by: disposeBag)
         
        // When
        scheduler.createColdObservable([.next(1, ("test"))])
            .subscribe(onNext: { [weak self] (keyword) in
                _ = self?.searchUseCase.search(keyword: keyword)
            })
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        let recordedEvents = Recorded.events(
            .next(1, 1),
            .completed(1)
        )
        XCTAssertEqual(currentPage.events, recordedEvents)
    }
    
    func testLoadMore() {
        // Given
        let currentPage = scheduler.createObserver(Int.self)
        
        apiServiceSpy.page
            .bind(to: currentPage)
            .disposed(by: disposeBag)
         
        // When
        scheduler.createColdObservable([.next(1, ())])
            .subscribe(onNext: { [weak self] _ in
                _ = self?.searchUseCase.loadMoreImages()
            })
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        // Then
        let recordedEvents = Recorded.events(
            .next(1, 2),
            .completed(1)
        )
        XCTAssertEqual(currentPage.events, recordedEvents)
    }
}
