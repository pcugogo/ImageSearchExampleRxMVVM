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
    var searchUseCase: SearchUseCaseType!
    
    override func setUp() {
        super.setUp()
        self.searchUseCase = SearchUseCase(apiService: apiServiceSpy)
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
    }

    func testSearchImage() {
        searchUseCase.searchImage(keyword: "test")
            .subscribe(onNext: { [weak self] (result) in
                switch result {
                case .success:
                    XCTAssertTrue(self?.apiServiceSpy.page == 1)
                case .failure(let error):
                    XCTFail(error.reason)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func testLoadMore() {
        searchUseCase.loadMoreImage()
            .subscribe(onNext: { [weak self] (result) in
                switch result {
                case .success:
                    XCTAssertTrue(self?.apiServiceSpy.page == 2)
                case .failure(let error):
                    XCTFail(error.reason)
                }
            })
            .disposed(by: disposeBag)
    }
}
