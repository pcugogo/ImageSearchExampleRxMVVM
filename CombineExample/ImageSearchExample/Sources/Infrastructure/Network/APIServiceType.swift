//
//  APIServiceType.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/11/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Combine

protocol APIServiceType {
    func request<T: Decodable>(api: API) -> AnyPublisher<T, NetworkError>
}
