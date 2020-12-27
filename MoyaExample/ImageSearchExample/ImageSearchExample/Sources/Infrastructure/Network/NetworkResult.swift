//
//  NetworkResult.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/27.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

enum NetworkResult<T: Codable> {
    case success(T)
    case failure(NetworkError)
}

extension NetworkResult {
    func response() -> T? {
        guard case .success(let response) = self else {
            return nil
        }
        return response
    }
    
    func error() -> NetworkError? {
        guard case .failure(let error) = self else {
            return nil
        }
        return error
    }
}
