//
//  APIServiceFake.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift
import XCTest
@testable import ImageSearchExample

struct APIServiceFake: APIServiceType {
    
    private let dummyData: DummyDataType
    
    init(dummyData: DummyDataType) {
        self.dummyData = dummyData
    }
    
    func request<T: Codable>(api: API) -> NetworkResult<T> {
        return Observable.create { emitter in
            guard let data = self.dummyData.jsonString.data(using: .utf8) else {
                XCTFail("DummyData jsonString Type casting Failed")
                return Disposables.create()
            }
            guard let imageSearchResponse = try? JSONDecoder().decode(T.self, from: data) else {
                XCTFail(DataResponseError.decoding.reason)
                return Disposables.create()
            }
            emitter.onNext(.success(imageSearchResponse))
            print(imageSearchResponse)
            return Disposables.create()
        }
    }
}
