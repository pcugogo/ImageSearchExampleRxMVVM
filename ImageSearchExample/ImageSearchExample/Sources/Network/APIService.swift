//
//  APIService.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Alamofire
import RxSwift

typealias NetworkResult<T> = Observable<Result<T, NetworkError>>

enum NetworkError: Error {
    case unknown
    case request
    
    var reason: String {
        switch self {
        case .unknown:
            return "알 수 없는 오류가 발생했습니다"
        case .request:
            return "서버 요청이 실패하였습니다.\n잠시 후에 다시 이용해주세요."
        }
    }
}

protocol APIServiceType {
    func request<T: Codable>(api: API) -> NetworkResult<T>
}

struct APIService: APIServiceType {
    func request<T: Codable>(api: API) -> NetworkResult<T> {
        return Observable.create { observer in
            api
                .dataRequest()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            observer.onNext(.failure(NetworkError.unknown))
                            return
                        }
                        do {
                            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(.success(decodedResponse))
                        } catch {
                            print("\(T.self), \(error)")
                        }
                    case .failure:
                        observer.onNext(.failure(NetworkError.request))
                    }
                }
            return Disposables.create()
        }
    }
}
