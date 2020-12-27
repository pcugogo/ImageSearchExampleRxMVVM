//
//  SearchUseCaseTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 13/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa
import Nimble

@testable import ImageSearchExample

final class SearchUseCaseTests: XCTestCase {
    var disposeBag = DisposeBag()
    let apiServiceSpy: SearchAPIServiceSpyType = SearchAPIServiceSpy()
    var searchRepository: SearchRepositoryType!
    var searchUseCase: SearchUseCaseType!
    
    override func setUp() {
        super.setUp()
        searchRepository = SearchRepository(apiService: apiServiceSpy)
        self.searchUseCase = SearchUseCase(searchRepository: searchRepository)
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
    }

    func testSearchImage() {
        searchUseCase.search(keyword: "test")
            .subscribe(onNext: { [weak self] _ in
                XCTAssertTrue(self?.apiServiceSpy.page == 1)
            })
            .disposed(by: disposeBag)
    }
    
    func testLoadMore() {
        searchUseCase.loadMoreImages()
            .subscribe(onNext: { [weak self] _ in
                XCTAssertTrue(self?.apiServiceSpy.page == 2)
            })
            .disposed(by: disposeBag)
    }
}
