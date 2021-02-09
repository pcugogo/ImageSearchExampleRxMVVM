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
    
    func request<T: Decodable>(_ modelType: T.Type, api: API) -> Single<T> {
        return Single.create { single in
            api.dataRequest()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            single(.failure(NetworkError.unknown))
                            return
                        }
                        single(data.decode(modelType))
                    case .failure(let error):
                        single(.failure(error.handling()))
                    }
                }
            return Disposables.create()
        }
    }
}
