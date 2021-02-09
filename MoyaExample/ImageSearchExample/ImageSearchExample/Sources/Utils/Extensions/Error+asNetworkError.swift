//
//  Error+asNetworkError.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2021/02/01.
//  Copyright © 2021 ChanWookPark. All rights reserved.
//

import Alamofire
import Moya

extension Error {
    
    func asNetworkError() -> NetworkError {
        if let decondingError = self as? DecodingError {
            print("Decoding Error : - \(decondingError)")
            return .unknown
        }
        
        guard let moyaError = self as? MoyaError else { return .unknown }
        
        switch moyaError {
        case let .statusCode(response):
            return NetworkError(rawValue: response.statusCode) ?? .unknown
        case let .underlying(error, _):
            if let afError = error as? AFError,
               let urlError = afError.underlyingError as? URLError {
                return NetworkError(rawValue: urlError.code.rawValue) ?? .unknown
            } else {
                return .unknown
            }
        default:
            return .unknown
        }
    }
}
