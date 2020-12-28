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
    
    func search(keyword: String)  -> Observable<SearchResponse>
    func loadMoreImages() -> Observable<SearchResponse>
}

final class SearchUseCase: SearchUseCaseType {
    
    private let imageSearchRepository: SearchRepositoryType
    private var currentPage = 1 // 1 ~ 50
    private var keyword: String = ""
    
    var isLastPage: Bool {
        return currentPage >= 50
    }
    
    init(imageSearchRepository: SearchRepositoryType = SearchRepository()) {
        self.imageSearchRepository = imageSearchRepository
    }
    
    func search(keyword: String) -> Observable<SearchResponse> {
        self.keyword = keyword
        currentPage = 1
        return imageSearchRepository.search(
            keyword: keyword,
            page: currentPage,
            numberOfImagesToLoad: 80
        )
    }
    
    func loadMoreImages() -> Observable<SearchResponse> {
        if !isLastPage {
            currentPage += 1
        }
        return imageSearchRepository.search(
            keyword: keyword,
            page: currentPage,
            numberOfImagesToLoad: 80
        )
    }
}
