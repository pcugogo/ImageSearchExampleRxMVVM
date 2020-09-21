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
    func searchImage(keyword: String, isNextPage: Bool) -> Result<SearchResponse>
}

final class SearchUseCase: SearchUseCaseType {
    private let apiService: APIServiceType
    private var currentPage = 1 //첫페이지 1
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
    }
    
    func searchImage(keyword: String, isNextPage: Bool) -> Result<SearchResponse> {
        currentPage = isNextPage ? currentPage + 1 : 1
        return apiService.request(api: API.getImages(query: keyword, page: currentPage, numberOfImagesToLoad: 30))
    }
}
