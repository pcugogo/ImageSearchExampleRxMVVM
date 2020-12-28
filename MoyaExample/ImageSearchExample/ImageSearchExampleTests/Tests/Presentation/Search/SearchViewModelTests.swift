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
import SCoordinator
import Nimble

@testable import ImageSearchExample

final class SearchViewModelTests: XCTestCase {
    
    var disposeBag = DisposeBag()
    let apiServiceSpy = SearchAPIServiceSpy()
    var searchRepository: SearchRepositoryType!
    var searchUseCase: SearchUseCaseType!
    var viewModel: SearchViewModel!
    
    override func setUp() {
        super.setUp()
        
        self.searchRepository = SearchRepository(apiService: apiServiceSpy)
        self.searchUseCase = SearchUseCase(searchRepository: searchRepository)
        
        self.viewModel = configureViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
    }
    
    func test_SearchViewModel_searchAction() {
        
        viewModel.output.imagesSections
            .skip(1)
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let page = self.apiServiceSpy.page else {
                    XCTFail("SearchUseCase_currentPage counting error")
                    return
                }
                expect(page).to(equal(1))
            })
            .drive(onNext: { imageSections in
                let searchImageDummy = SearchImageDummy()
                expect(imageSections[0].items.count).to(equal(searchImageDummy.totalCount))
                expect(imageSections[0].items[0].displaySitename).to(equal("DummyTest0"))
            })
            .disposed(by: disposeBag)
        
        viewModel.input.searchButtonAction.accept("test")
    }
    
    func test_SearchViewModel_moreFetch() {
        let searchImageDummy = SearchImageDummy()
        viewModel.output.imagesSections
            .skip(2)
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let page = self.apiServiceSpy.page else {
                    XCTFail("SearchUseCase_currentPage counting error")
                    return
                }
                expect(page).to(equal(2))
            })
            .drive(onNext: { imageSections in
                expect(imageSections[0].items.count).to(equal(searchImageDummy.totalCount * 2))
                expect(imageSections[0].items[0].displaySitename).to(equal("DummyTest0"))
            })
            .disposed(by: disposeBag)
        
        viewModel.input.willDisplayCell.accept(IndexPath(item: searchImageDummy.totalCount - 1, section: 0))
    }
}

extension SearchViewModelTests {
    func configureViewModel() -> SearchViewModel {
        let coordinator = SearchCoordinator(
            rootView: UINavigationController(),
            parentCoordinator: RootCoordinator(rootView: UIViewController())
        )
        let viewModel = SearchViewModel(
            coordinator: coordinator,
            searchUseCase: searchUseCase
        )
        return viewModel
    }
}
