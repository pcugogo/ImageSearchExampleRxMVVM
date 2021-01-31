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
    func search(keyword: String)  -> Observable<SearchResponse>
    func loadMoreImages() -> Observable<SearchResponse>
}

final class SearchUseCase: SearchUseCaseType {
    
    private let apiService: APIServiceType
    private var currentPage = 1 // 1 ~ 50
    private var keyword: String = ""
    
    var isLastPage: Bool {
        return currentPage >= 50
    }
    
    init(apiService: APIServiceType = APIService()) {
        self.apiService = apiService
    }
    
    func search(keyword: String) -> Observable<SearchResponse> {
        self.keyword = keyword
        currentPage = 1
        let api = API.getImages(query: keyword, page: currentPage, numberOfImagesToLoad: 80)
        return apiService.request(api: api)
            .asObservable()
    }
    
    func loadMoreImages() -> Observable<SearchResponse> {
        if !isLastPage {
            currentPage += 1
        }
        let api = API.getImages(query: keyword, page: currentPage, numberOfImagesToLoad: 80)
        return apiService.request(api: api)
            .asObservable()
    }
}
