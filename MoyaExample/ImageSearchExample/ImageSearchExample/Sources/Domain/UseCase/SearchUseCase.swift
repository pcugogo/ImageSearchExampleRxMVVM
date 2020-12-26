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
    
    func search(keyword: String)  -> Observable<NetworkResult<SearchResponse>>
    func loadMoreImages() -> Observable<NetworkResult<SearchResponse>>
}

final class SearchUseCase: SearchUseCaseType {
    
    private let imageSearchRepository: SearchRepositoryType
    private var currentPage = 1 //1 ~ 50
    private var keyword: String = ""
    
    var isLastPage: Bool {
        return currentPage >= 50
    }
    
    init(imageSearchRepository: SearchRepositoryType = SearchRepository()) {
        self.imageSearchRepository = imageSearchRepository
    }
    
    deinit {
        print("SearchUseCase deinit")
    }
    func search(keyword: String) -> Observable<NetworkResult<SearchResponse>> {
        self.keyword = keyword
        currentPage = 1
        return imageSearchRepository.search(
            keyword: keyword,
            page: currentPage,
            numberOfImagesToLoad: 80
        )
    }
    
    func loadMoreImages() -> Observable<NetworkResult<SearchResponse>> {
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
