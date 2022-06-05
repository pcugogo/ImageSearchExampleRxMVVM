//
//  APIServiceType.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/11/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift

protocol APIServiceType {
    func request<T: Decodable>(api: API) -> Single<T>
}
