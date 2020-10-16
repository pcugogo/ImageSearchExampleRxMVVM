//
//  SearchAPIServiceSpy.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 2020/09/23.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift
@testable import ImageSearchExample

protocol SearchAPIServiceSpyType: APIServiceType {
    var page: Int? { get }
}

final class SearchAPIServiceSpy: SearchAPIServiceSpyType {
    private(set) var page: Int?
    
    func request<T: Codable>(api: API) -> Single<T> {
        switch api {
        case .getImages(_, let page, _):
            self.page = page
        }
        let apiServiceFake = APIServiceFake(dummyData: SearchImageDummy())
        return apiServiceFake.request(api: api)
    }
}
