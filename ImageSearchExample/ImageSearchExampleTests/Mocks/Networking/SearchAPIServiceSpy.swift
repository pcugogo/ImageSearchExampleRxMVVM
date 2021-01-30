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
    var page: PublishSubject<Int> { get }
}

final class SearchAPIServiceSpy: SearchAPIServiceSpyType {
    private(set) var page: PublishSubject<Int> = .init()
    var disposeBag = DisposeBag()
    
    func request<T: Codable>(api: API) -> Single<T> {
        switch api {
        case .getImages(_, let page, _):
            Observable.just(page)
                .bind(to: self.page)
                .disposed(by: disposeBag)
        }
        let apiServiceFake = APIServiceFake(dummyData: SearchImageDummy())
        return apiServiceFake.request(api: api)
    }
}
