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
        
        if let underlyingError = self.underlyingError,
           let urlError = underlyingError as? URLError {
            return NetworkError(rawValue: urlError.code.rawValue) ?? .unknown
        }
        guard let statusCode = self.responseCode else { return .unknown }
        return NetworkError(rawValue: statusCode) ?? .unknown
    }
}
