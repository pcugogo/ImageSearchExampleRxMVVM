//
//  Data+Decode.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2021/02/09.
//  Copyright © 2021 ChanWookPark. All rights reserved.
//

import Foundation

extension Data {
    
    func decode<T: Decodable>(_ modelType: T.Type) -> Result<T, Error> {
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: self)
            return .success(decodedResponse)
        } catch {
            print("\(T.self): - \(error)")
            return .failure(NetworkError.unknown)
        }
    }
}
