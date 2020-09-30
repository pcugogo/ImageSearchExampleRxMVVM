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
    func searchImage(keyword: String, isNextPage: Bool) -> NetworkResult<SearchResponse>
}

final class SearchUseCase: SearchUseCaseType {
    private let apiService: APIServiceType
    private var currentPage = 1 //1 ~ 50
    var isLastPage: Bool {
        return currentPage >= 50
    }
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
    }
    
    func searchImage(keyword: String, isNextPage: Bool) -> NetworkResult<SearchResponse> {
        isNextPage ? appendPage() : resetPage()
        return apiService.request(api: API.getImages(query: keyword, page: currentPage, numberOfImagesToLoad: 80))
    }
    
    private func resetPage() {
        currentPage = 1
    }
    private func appendPage() {
        if !isLastPage {
            currentPage += 1
        }
    }
}
