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
                
                if let decondingError = $0 as? DecodingError {
                    print("Decoding Error : - \(String(describing: T.self)), \(decondingError)")
                    return .just(.failure(.unknown))
                }
                
                guard let moyaError = $0 as? MoyaError else { return .just(.failure(.unknown)) }
                
                switch moyaError {
                case let .statusCode(response):
                    return .just(.failure(handling(for: response.statusCode)))
                case let .underlying(error, _):
                    if let afError = error as? AFError,
                       let urlError = afError.underlyingError as? URLError {
                        return .just(.failure(handling(for: urlError)))
                    } else {
                        return .just(.failure(.unknown))
                    }
                default:
                    return .just(.failure(.unknown))
                }
            }
    }
}

extension APIService {
    func handling(for urlError: URLError) -> NetworkError {
        return NetworkError(rawValue: urlError.code.rawValue) ?? .unknown
    }
    
    func handling(for httpStatusCode: Int) -> NetworkError {
        print(httpStatusCode)
        return NetworkError(rawValue: httpStatusCode) ?? .unknown
    }
}
