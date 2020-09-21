//
//  SearchViewModelTests.swift
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

final class SearchViewModelTests: XCTestCase {
    var disposeBag = DisposeBag()
    let apiServiceSpy = APIServiceSpy(dummyData: SearchImageDummy())
    var searchUseCase: SearchUseCaseType!
    var viewModel: SearchViewModelType!
    
    override func setUp() {
        super.setUp()
        self.searchUseCase = SearchUseCase(apiService: apiServiceSpy)
        self.viewModel = SearchViewModel(searchUseCase: searchUseCase)
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
    }
    
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
