//
//  APIService.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Alamofire
import RxSwift

typealias NetworkResult<T> = Observable<Result<T, DataResponseError>>

enum DataResponseError: Error {
    case url
    case request
    case decoding
    
    var reason: String {
        switch self {
        case .url:
            return "url is empty"
        case .request:
            return "request faild"
        case .decoding:
            return "decoding error"
        }
    }
}

protocol APIServiceType {
    func request<T: Codable>(api: API) -> NetworkResult<T>
}

struct APIService: APIServiceType {
    func request<T: Codable>(api: API) -> NetworkResult<T> {
        return Observable.create { emitter in
            api
                .dataRequest()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data,
                              let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                            emitter.onNext(.failure(DataResponseError.decoding))
                            return
                        }
                        emitter.onNext(.success(decodedResponse))
                    case .failure:
                        emitter.onNext(.failure(DataResponseError.request))
                    }
                }
            return Disposables.create()
        }
    }
}
