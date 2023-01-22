//
//  APIService.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Alamofire
import Combine

struct APIService: APIServiceType {
    func request<T: Decodable>(api: API) -> AnyPublisher<T, NetworkError> {
        return Deferred {
            Future { promise in
                api.dataRequest()
                    .responseJSON { response in
                        switch response.result {
                        case .success:
                            guard let data = response.data else {
                                promise(.failure(NetworkError.unknown))
                                return
                            }
                            do {
                                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                                promise(.success(decodedResponse))
                            } catch {
                                print("\(T.self): - \(error)")
                                promise(.failure(NetworkError.unknown))
                            }
                        case .failure(let error):
                            promise(.failure(error.handling()))
                        }
                    }
            }
        }
        .eraseToAnyPublisher()
    }
}
