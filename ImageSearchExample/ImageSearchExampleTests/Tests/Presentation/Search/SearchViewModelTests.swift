//
//  SearchViewModelTests.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa

@testable import ImageSearchExample

final class SearchViewModelTests: XCTestCase {
    var disposeBag = DisposeBag()
    let apiServiceStub = APIServiceStub()
    var searchRepository: SearchRepositoryType!
    var searchUseCase: SearchUseCaseType!
    var viewModel: SearchViewModel!
    let searchResponseDummy = SearchResponseDummy()
    
    override func setUp() {
        super.setUp()
        
        self.searchRepository = SearchRepository(apiService: apiServiceStub)
        self.searchUseCase = SearchUseCase(imageSearchRepository: searchRepository)
        
        self.viewModel = configureViewModel()
    }
    
    func testSearch() {
        let expectation = XCTestExpectation(description: #function)
        
        viewModel.output.imageDatas
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] imageDatas in
                guard let self = self else { return }
                XCTAssertEqual(imageDatas.count, self.searchResponseDummy.per)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.input.searchWithKeyword.accept("test")
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testLoadMore() {
        let expectation = XCTestExpectation(description: #function)
        
        viewModel.input.searchWithKeyword.accept("test")
        viewModel.output.imageDatas
            .asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] imageDatas in
                guard let self = self else { return }
                XCTAssertEqual(imageDatas.count, self.searchResponseDummy.per * 2)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.input.willDisplayCellIndexPath.accept(IndexPath(item: 1, section: 0))
        
        wait(for: [expectation], timeout: 1)
    }
}

extension SearchViewModelTests {
    func configureViewModel() -> SearchViewModel {
        let coordinator = SearchCoordinator(rootView: .init())
        let viewModel = SearchViewModel(
            coordinator: coordinator,
            searchUseCase: searchUseCase
        )
        return viewModel
    }
}
