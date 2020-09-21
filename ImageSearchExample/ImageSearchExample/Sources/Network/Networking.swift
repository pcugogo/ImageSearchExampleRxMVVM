//
//  Networking.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

typealias Result<T> = Single<DataResponse<T, DataResponseError>>

enum DataResponse<T, U: Error> {
    case success(T)
    case failure(U)
}

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
    func request<T: Codable>(api: API) -> Result<T>
}

struct APIService: APIServiceType {
    func request<T: Codable>(api: API) -> Result<T> {
        return Single.create { emitter in
            api
                .dataRequest()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data,
                            let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                                emitter(.error(DataResponseError.decoding))
                                return
                        }
                        emitter(.success(DataResponse.success(decodedResponse)))
                    case .failure:
                        emitter(.error(DataResponseError.request))
                    }
            }
            return Disposables.create()
        }
    }
}
