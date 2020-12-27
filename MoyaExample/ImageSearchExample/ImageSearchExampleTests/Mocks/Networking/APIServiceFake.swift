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
    
    func request<T: Codable>(api: API) -> Single<NetworkResult<T>> {
        return Single.create { single in
            guard let data = self.dummyData.jsonString.data(using: .utf8) else {
                XCTFail("DummyData jsonString Type casting Failed")
                return Disposables.create()
            }
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                single(.success(.success(decodedResponse)))
            } catch {
                XCTFail("\(T.self), \(error)")
            }
            return Disposables.create()
        }
    }
}
