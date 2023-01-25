//
//  SearchAPIServiceSpy.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 2020/09/23.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Combine
@testable import ImageSearchExample

protocol SearchAPIServiceSpyType: APIServiceType {
    var page: PassthroughSubject<Int> { get }
}

final class SearchAPIServiceSpy: SearchAPIServiceSpyType {
    private(set) var page = PassthroughSubject<Int>()
    var cancellables: CancellableSet = []
    
    func request<T: Decodable>(api: API) -> Single<T> {
        switch api {
        case .getImages(_, let page, _):
            Just(page)
                .sink(receiveValue: {
                    self.page.send($0)
                })
                .store(in: &cancellables)
        }
        let apiServiceFake = APIServiceFake(dummyData: SearchImageDummy())
        return apiServiceFake.request(api: api)
    }
}
