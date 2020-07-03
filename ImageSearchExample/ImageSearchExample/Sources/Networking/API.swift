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
        static let apiKey = ""
    }
    private var path: String {
        switch self {
        case .getImages:
            return "/v2/search/image"
        }
    }
    var url: URL {
        let url = (try? Constant.baseURLString.asURL())!
        return url.appendingPathComponent(path)
    }
    var prameters: [String:Any] {
        switch self {
        case let .getImages(query, page, numberOfImagesToLoad):
            return ["query":query, "page":page, "size":numberOfImagesToLoad]
        }
    }
    var header: HTTPHeaders {
        return HTTPHeaders(["Authorization":Constant.apiKey])
    }
}
