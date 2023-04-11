//
//  AFError+handling.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2021/02/09.
//  Copyright © 2021 ChanWookPark. All rights reserved.
//

import Alamofire

extension AFError {
    func handling() -> NetworkError {
        var networkError: NetworkError?
        
        if let underlyingError = underlyingError, let urlError = underlyingError as? URLError {
            networkError = NetworkError(rawValue: urlError.code.rawValue)
        }
        
        if let statusCode = responseCode {
            networkError = NetworkError(rawValue: statusCode)
        }
        
        return networkError ?? .unknown
    }
}
