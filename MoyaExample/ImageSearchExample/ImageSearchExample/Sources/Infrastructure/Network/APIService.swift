//
//  APIService.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Alamofire
import RxSwift
import Moya

struct APIService: APIServiceType {
    
    private let provider: MoyaProvider<API>
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 3.0
        let session = Alamofire.Session(configuration: configuration)
            
        provider = MoyaProvider<API>(session: session)
    }
    
    func request<T: Codable>(api: API) -> Single<NetworkResult<T>> {
        return provider.rx.request(api)
            .filterSuccessfulStatusCodes()
            .map {
                try JSONDecoder().decode(T.self, from: $0.data)
            }
            .map { .success($0) }
            .catchError {
                return .just(.failure($0.asNetworkError()))
            }
    }
}
