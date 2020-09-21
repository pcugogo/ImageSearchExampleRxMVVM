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
    let apiServiceSpy = APIServiceFake(dummyData: SearchImageDummy())
    var searchUseCase: SearchUseCaseType!
    
    override func setUp() {
        super.setUp()
        self.searchUseCase = SearchUseCase(apiService: apiServiceSpy)
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
    }

    func testFetchNextPage() {
        searchUseCase.searchImage(keyword: "test", isNextPage: true)
            .subscribe(onSuccess: { result in
                switch result {
                case .success(let response):
                    print(response.images.count, "testFetchNextPage success")
                case .failure(let error):
                    XCTFail(error.reason)
                }
            })
            .disposed(by: disposeBag)
    }
}
