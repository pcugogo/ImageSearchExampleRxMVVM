//
//  SearchRepository.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/16.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
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
        return apiService.request(api: api).asObservable()
    }
}
