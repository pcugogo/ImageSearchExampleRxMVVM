//
//  SearchRepository.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2021/01/18.
//  Copyright © 2021 ChanWookPark. All rights reserved.
//

import RxSwift

struct SearchRepository {
    
    private let apiService: APIServiceType
    
    init(apiService: APIServiceType = APIService()) {
        self.apiService = apiService
    }
}

extension SearchRepository: SearchRepositoryType {
    func search(
        keyword: String,
        page: Int,
        numberOfImagesToLoad: Int
    ) -> Observable<SearchResponse> {
        let api = API.getImages(query: keyword, page: page, numberOfImagesToLoad: numberOfImagesToLoad)
        return apiService.request(SearchResponse.self, api: api).asObservable()
    }
}
