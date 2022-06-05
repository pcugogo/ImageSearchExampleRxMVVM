//
//  SearchUseCase.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift

protocol SearchUseCaseType {
    func search(keyword: String, page: Int)  -> Observable<SearchResponse>
}

final class SearchUseCase: SearchUseCaseType {
    private let imageSearchRepository: SearchRepositoryType
    
    init(imageSearchRepository: SearchRepositoryType = SearchRepository()) {
        self.imageSearchRepository = imageSearchRepository
    }
    
    func search(keyword: String, page: Int) -> Observable<SearchResponse> {
        return imageSearchRepository.search(
            keyword: keyword,
            page: page,
            numberOfImagesToLoad: 80
        )
    }
}
