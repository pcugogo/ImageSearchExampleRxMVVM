//
//  APIServiceFake.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Combine
import XCTest
@testable import ImageSearchExample

struct APIServiceFake: APIServiceType {
    
    private let dummyData: DummyDataType
    
    init(dummyData: DummyDataType) {
        self.dummyData = dummyData
    }
    
    func request<T: Decodable>(api: API) -> AnyPublisher<T, NetworkError> {
        return Deferred {
            Future { promise in
                guard let data = self.dummyData.jsonString.data(using: .utf8) else {
                    XCTFail("DummyData jsonString Type casting Failed")
                }
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    promise(.success(decodedResponse))
                } catch {
                    XCTFail("\(T.self), \(error)")
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
