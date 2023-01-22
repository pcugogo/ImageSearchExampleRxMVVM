//
//  SearchUseCaseTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 13/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import XCTest
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
    }
    
    func testLoadMore() {
    }
}
