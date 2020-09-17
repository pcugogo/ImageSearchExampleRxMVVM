//
//  Networking.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift

typealias ImageSearchResult<T> = DataResponse<T, DataResponseError>

enum DataResponse<T, U: Error> {
    case success(T)
    case failure(U)
}

enum DataResponseError: Error {
    case url
    case request
    case decoding
    
    var reason: String {
        switch self {
        case .url:
            return "url is empty"
        case .request:
            return "request faild"
        case .decoding:
            return "decoding error"
        }
    }
}

protocol APIServiceType {
    func imageSearch(keyword: String, page: Int, numberOfImagesToLoad: Int) -> Single<ImageSearchResult<SearchResponse>>
}

struct APIService: APIServiceType {
    func imageSearch(keyword: String, page: Int, numberOfImagesToLoad: Int) -> Single<ImageSearchResult<SearchResponse>> {
        let api = API.getImages(query: keyword, page: page, numberOfImagesToLoad: numberOfImagesToLoad)
        return Single.create { single in
            let request = AF.request(api.url,
                                     method: .get,
                                     parameters: api.prameters,
                                     encoding: URLEncoding.default,
                                     headers: api.header)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data,
                            let decodedResponse = try? JSONDecoder().decode(SearchResponse.self, from: data) else {
                                single(.success(DataResponse.failure(DataResponseError.decoding)))
                                return
                        }
                        single(.success(DataResponse.success(decodedResponse)))
                    case .failure:
                        single(.success(DataResponse.failure(DataResponseError.request)))
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
