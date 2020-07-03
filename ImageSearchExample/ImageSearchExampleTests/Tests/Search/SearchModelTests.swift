//
//  SearchModelTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import XCTest
import RxSwift
import RxCocoa

@testable import ImageSearchExample

final class SearchModelTests: XCTestCase {
    var disposeBag = DisposeBag()
    let apiServiceSpy = APIServiceSpy()
    var model: SearchModelType!
    var viewModel: SearchViewModelType!
    
    override func setUp() {
        super.setUp()
        self.model = SearchModel(apiService: apiServiceSpy)
        self.viewModel = SearchViewModel(model: model)
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
    }
    
    func testFetchFirstPage() {
        model.searchImage(keyword: "test", isNextPage: false)
            .do(onSuccess: {[weak self] _ in
                guard let self = self else { return }
                XCTAssertEqual(self.apiServiceSpy.currentPage, 1, "Not the first page")
            })
            .subscribe(onSuccess: { result in
                switch result {
                case .success(let response):
                    print(response.documents.count, "success")
                case .failure(let error):
                    XCTFail(error.reason)
                }
            })
            .disposed(by: disposeBag)
    }
    func testFetchNextPage() {
        model.searchImage(keyword: "test", isNextPage: true)
        .do(onSuccess: {[weak self] _ in
            guard let self = self else { return }
            XCTAssertEqual(self.apiServiceSpy.currentPage, 2, "Next Page Error")
        })
        .subscribe(onSuccess: { result in
            switch result {
            case .success(let response):
                print(response.documents.count, "success")
            case .failure(let error):
                XCTFail(error.reason)
            }
        })
        .disposed(by: disposeBag)
    }
}
