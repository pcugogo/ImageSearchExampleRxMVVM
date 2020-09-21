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
    let apiServiceSpy = APIServiceSpy(dummyData: SearchImageDummy())
    var searchUseCase: SearchUseCaseType!
    
    override func setUp() {
        super.setUp()
        self.searchUseCase = SearchUseCase(apiService: apiServiceSpy)
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
    }

    func testFetchFirstPage() {
        searchUseCase.searchImage(keyword: "test", isNextPage: false)
//            .do(onSuccess: { [weak self] _ in
//                guard let self = self else { return }
//                expect(self.searchUseCase.currentPage).to(equal(1))
//            })
            .subscribe(onSuccess: { result in
                switch result {
                case .success(let response):
                    print(response.images.count, "testFetchFirstPage success")
                case .failure(let error):
                    XCTFail(error.reason)
                }
            })
            .disposed(by: disposeBag)
    }
    func testFetchNextPage() {
        searchUseCase.searchImage(keyword: "test", isNextPage: true)
//        .do(onSuccess: { [weak self] _ in
//            guard let self = self else { return }
//            expect(self.searchUseCase.currentPage).to(equal(2))
//        })
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
