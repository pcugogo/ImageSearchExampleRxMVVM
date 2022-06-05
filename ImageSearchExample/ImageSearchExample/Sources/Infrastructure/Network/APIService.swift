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
    func request<T: Decodable>(api: API) -> Single<T> {
        return Single.create { single in
            api.dataRequest()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            single(.failure(NetworkError.unknown))
                            return
                        }
                        do {
                            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                            single(.success(decodedResponse))
                        } catch {
                            print("\(T.self): - \(error)")
                            single(.failure(NetworkError.unknown))
                        }
                    case .failure(let error):
                        single(.failure(error.handling()))
                    }
                }
            return Disposables.create()
        }
    }
}
