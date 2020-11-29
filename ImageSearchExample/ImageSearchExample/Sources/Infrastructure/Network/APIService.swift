//
//  APIService.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Alamofire
import RxSwift

struct APIService: APIServiceType {
    func request<T: Codable>(api: API) -> Single<T> {
        return Single.create { single in
            api
                .dataRequest()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            single(.error(NetworkError.unknown))
                            return
                        }
                        do {
                            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                            single(.success(decodedResponse))
                        } catch {
                            print("\(T.self), \(error)")
                        }
                    case .failure(let error):
                        if let underlyingError = error.underlyingError,
                           let urlError = underlyingError as? URLError {
                            single(.error(handling(for: urlError)))
                        }
                        guard let httpResponse = response.response else {
                            single(.error(NetworkError.unknown))
                            return
                        }
                        single(.error(handling(for: httpResponse.statusCode)))
                    }
                }
            return Disposables.create()
        }
    }
}

extension APIService {
    
    func handling(for urlError: URLError) -> NetworkError {
        print(urlError.code, "cellHeights[indexPath] ?? ")
        switch urlError.code {
        case .timedOut:
            return .timeOut
        case .notConnectedToInternet, .dataNotAllowed:
            return .notConnected
        default:
            return .unknown
        }
    }
    
    func handling(for httpStatusCode: Int) -> NetworkError {
        
        switch httpStatusCode {
        case 400...499:
            return .badRequest
        case 500...599:
            return .serverError
        default:
            return .unknown
        }
    }
}
