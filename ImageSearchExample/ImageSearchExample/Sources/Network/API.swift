//
//  API.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import Alamofire

enum API {
    case getImages(query: String, page: Int, numberOfImagesToLoad: Int)
}

extension API {
    struct Constant {
        static let baseURLString = "https://dapi.kakao.com"
        static let apiKey = "KakaoAK 25cd80a89c59043f4252746092279d2b"
    }
    
    private var path: String {
        switch self {
        case .getImages:
            return "/v2/search/image"
        }
    }
    
    private var url: URL {
        let url = (try? Constant.baseURLString.asURL())!
        return url.appendingPathComponent(path)
    }
    
    private var prameters: [String:Any] {
        switch self {
        case let .getImages(query, page, numberOfImagesToLoad):
            return ["query":query, "page":page, "size":numberOfImagesToLoad]
        }
    }
    
    private var header: HTTPHeaders {
        return HTTPHeaders(["Authorization":Constant.apiKey])
    }
    
    func dataRequest() -> DataRequest {
        AF.request(self.url,
                   method: .get,
                   parameters: self.prameters,
                   encoding: URLEncoding.default,
                   headers: self.header)
            .validate()
    }
}
