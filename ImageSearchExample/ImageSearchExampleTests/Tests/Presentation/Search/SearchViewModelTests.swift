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
    let apiServiceSpy = SearchAPIServiceSpy()
    var searchUseCase: SearchUseCaseType!
    var viewModel: SearchViewModelType!
    
    override func setUp() {
        super.setUp()
        self.searchUseCase = SearchUseCase(apiService: apiServiceSpy)
        let dependency = SearchCoordinator.Dependency(searchUseCase: searchUseCase)
        self.viewModel = SearchViewModel(coordinator: SearchCoordinator(navigationController: UINavigationController()),
                                         dependency: dependency)
    }
    
    override func tearDown() {
        super.tearDown()
        print("tearDown")
    }
    
    func testSearchViewModel_searchAction() {
        viewModel.outputs.imagesCellItems
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
        
        Observable.just("keyword")
            .bind(to: viewModel.inputs.searchButtonAction)
            .disposed(by: disposeBag)
    }
    
    func testSearchViewModel_moreFetch() {
        let searchImageDummy = SearchImageDummy()
        viewModel.outputs.imagesCellItems
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
        
        Observable.just("keyword")
            .bind(to: viewModel.inputs.searchButtonAction)
            .disposed(by: disposeBag)
        
        viewModel.inputs.willDisplayCell.accept(IndexPath(item: searchImageDummy.totalCount - 1, section: 0))
    }
}
