//
//  APIServiceFake.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift
@testable import ImageSearchExample

final class APIServiceFake: APIServiceType {
    let dummyData: DummyDataType
    
    init(dummyData: DummyDataType) {
        self.dummyData = dummyData
    }
    
    func request<T: Codable>(api: API) -> NetworkResult<T> {
        return Observable.create { [weak self] emitter in
            guard let data = self?.dummyData.jsonString.data(using: .utf8),
                let imageSearchResponse = try? JSONDecoder().decode(T.self, from: data) else {
                    emitter.onNext(.failure(.decoding))
                    return Disposables.create()
            }
            emitter.onNext(.success(imageSearchResponse))
            return Disposables.create()
        }
    }
}
