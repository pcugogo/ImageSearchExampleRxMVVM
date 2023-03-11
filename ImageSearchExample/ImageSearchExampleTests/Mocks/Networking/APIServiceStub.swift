//
//  APIServiceStub.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 2020/09/23.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift
import XCTest
@testable import ImageSearchExample

final class APIServiceStub: APIServiceType {
    private(set) var page: PublishSubject<Int> = .init()
    var disposeBag = DisposeBag()
    
    func request<T: Decodable>(api: API) -> Single<T> {
        return Single.create { single in
            guard let data = api.dummyData.jsonString.data(using: .utf8) else {
                XCTFail("\(#line)")
                return Disposables.create()
            }
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                single(.success(decodedResponse))
            } catch {
                XCTFail("\(T.self), \(error)")
            }
            return Disposables.create()
        }
    }
}

private extension API {
    var dummyData: DummyDataType {
        switch self {
        case .getImages:
            return SearchResponseDummy()
        }
    }
}
