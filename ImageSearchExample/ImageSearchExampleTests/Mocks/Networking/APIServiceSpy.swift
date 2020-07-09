//
//  APIServiceSpy.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import RxSwift

@testable import ImageSearchExample

final class APIServiceSpy: APIServiceType {
    
    var currentPage: Int?
    
    func imageSearch(keyword: String, page: Int, numberOfImagesToLoad: Int) -> Single<ImageSearchResult<SearchResponse>> {
        currentPage = page
        let dummyData = SearchImageDummy()
        let data = dummyData.imageDataJSONString.data(using: .utf8)!
        do {
            let imageSearchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
            return .just(.success(imageSearchResponse))
        } catch {
            return .just(.failure(.decoding))
        }
    }
}
