//
//  API.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Alamofire

enum API {
    case getImages(query: String, page: Int, numberOfImagesToLoad: Int)
}

extension API {
    private enum Constant {
        static let baseURLString = "https://dapi.kakao.com"
        static let apiKey = ""
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
    
    private var httpMethod: HTTPMethod {
        switch self {
        case .getImages:
            return .get
        }
    }
    
    func dataRequest() -> DataRequest {
        AF.request(
            url,
            method: httpMethod,
            parameters: prameters,
            encoding: URLEncoding.default,
            headers: header
        )
            .validate()
    }
}
