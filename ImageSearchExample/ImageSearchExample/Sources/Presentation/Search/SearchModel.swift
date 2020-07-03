//
//  SearchManager.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

protocol SearchModelType {
    func searchImage(keyword: String, isNextPage: Bool) -> Single<ImageSearchResult<SearchResponse>>
}

struct SearchModel: SearchModelType {
    
    private let apiService: APIServiceType
    private var currentPage = BehaviorRelay(value: 1) //첫페이지 1
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
    }
    
    func searchImage(keyword: String, isNextPage: Bool) -> Single<ImageSearchResult<SearchResponse>> {
        isNextPage ? currentPage.accept(currentPage.value + 1) : currentPage.accept(1)
        return apiService.imageSearch(keyword: keyword, page: currentPage.value, numberOfImagesToLoad: 30)
    }
}
