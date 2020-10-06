//
//  SearchUseCase.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

protocol SearchUseCaseType {
    var isLastPage: Bool { get }
    func searchImage(keyword: String)  -> NetworkResult<SearchResponse>
    func loadMoreImage() -> NetworkResult<SearchResponse>
}

final class SearchUseCase: SearchUseCaseType {
    
    private let apiService: APIServiceType
    private var currentPage = 1 //1 ~ 50
    private var keyword: String = ""
    
    var isLastPage: Bool {
        return currentPage >= 50
    }
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
    }
    
    func searchImage(keyword: String) -> NetworkResult<SearchResponse> {
        self.keyword = keyword
        currentPage = 1
        return apiService.request(api: API.getImages(query: keyword, page: currentPage, numberOfImagesToLoad: 80))
    }
    
    func loadMoreImage() -> NetworkResult<SearchResponse> {
        if !isLastPage {
            currentPage += 1
        }
        return apiService.request(api: API.getImages(query: keyword, page: currentPage, numberOfImagesToLoad: 80))
    }
}

