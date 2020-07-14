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
import Nimble

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
    
    // Model Tests
    func testFetchFirstPage() {
        model.searchImage(keyword: "test", isNextPage: false)
            .do(onSuccess: {[weak self] _ in
                guard let self = self else { return }
                expect(self.apiServiceSpy.currentPage).to(equal(1))
            })
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
        model.searchImage(keyword: "test", isNextPage: true)
        .do(onSuccess: {[weak self] _ in
            guard let self = self else { return }
            expect(self.apiServiceSpy.currentPage).to(equal(2))
        })
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
    
    // ViewModel Tests
    func testSearchAction() {
        var emitCount = 0
        viewModel.outputs.imagesCellItems
            .drive(onNext: { imageDatas in
                if emitCount == 1 { //imagesCellItems: BehaviorRelay 초기 값 패스
                    expect(imageDatas.isEmpty).to(beFalse())
                }
                emitCount += 1
            })
            .disposed(by: disposeBag)
        
        Observable.just("keyword")
            .bind(to: viewModel.inputs.searchButtonAction)
            .disposed(by: disposeBag)
    }
    
    func testMoreFetch() {
        viewModel.outputs.imagesCellItems
            .drive(onNext: { imageDatas in
                let searchImageDummy = SearchImageDummy()
                if imageDatas.count > searchImageDummy.count { //초기 검색은 패스
                    expect(imageDatas.count).to(equal(searchImageDummy.count * 2))
                }
            })
            .disposed(by: disposeBag)
        
        //초기 검색
        Observable.just("keyword")
            .bind(to: viewModel.inputs.searchButtonAction)
            .disposed(by: disposeBag)
        
        //마지막 셀
        viewModel.inputs.willDisplayCell.accept(IndexPath(item: 1, section: 0))
    }
}
