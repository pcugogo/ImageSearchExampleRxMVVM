//
//  APIService.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Alamofire
import RxSwift

enum NetworkError: Error {
    case unknown
    case request
    
    var message: String {
        switch self {
        case .unknown:
            return "알 수 없는 오류가 발생했습니다"
        case .request:
            return "서버 요청이 실패하였습니다.\n잠시 후에 다시 이용해주세요."
        }
    }
}

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
                    case .failure:
                        single(.error(NetworkError.request))
                    }
            }
            return Disposables.create()
        }
    }
}
