//
//  SearchUseCase.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift

protocol SearchUseCaseType {
    var isLastPage: Bool { get }
    
    func search(keyword: String)  -> Observable<NetworkResult<SearchResponse>>
    func loadMoreImages() -> Observable<NetworkResult<SearchResponse>>
}

final class SearchUseCase: SearchUseCaseType {
    
    private let searchRepository: SearchRepositoryType
    private var currentPage = 1 //1 ~ 50
    private var keyword: String = ""
    
    var isLastPage: Bool {
        return currentPage >= 50
    }
    
    init(searchRepository: SearchRepositoryType = SearchRepository()) {
        self.searchRepository = searchRepository
    }
    
    deinit {
        print("SearchUseCase deinit")
    }
    func search(keyword: String) -> Observable<NetworkResult<SearchResponse>> {
        self.keyword = keyword
        currentPage = 1
        return searchRepository.search(
            keyword: keyword,
            page: currentPage,
            numberOfImagesToLoad: 80
        )
    }
    
    func loadMoreImages() -> Observable<NetworkResult<SearchResponse>> {
        if !isLastPage {
            currentPage += 1
        }
        return searchRepository.search(
            keyword: keyword,
            page: currentPage,
            numberOfImagesToLoad: 80
        )
    }
}
