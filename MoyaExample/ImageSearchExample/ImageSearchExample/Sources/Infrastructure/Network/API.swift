//
//  API.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Alamofire
import Moya

enum API {
    case getImages(query: String, page: Int, numberOfImagesToLoad: Int)
}

extension API: TargetType {
    
    // MARK: Constants
    
    private enum Constants {
        static let baseURLString = "https://dapi.kakao.com"
        static let apiKey = ""
    }
    
    // MARK: baseURL
    
    var baseURL: URL {
        return URL(string: Constants.baseURLString)!
    }
    
    // MARK: method
    
    var method: Moya.Method {
        switch self {
        case .getImages:
            return .get
        }
    }
    
    // MARK: sampleData
    
    var sampleData: Data {
        return Data()
    }
    
    // MARK: headers
    
    var headers: [String : String]? {
        ["Authorization":Constants.apiKey]
    }
    
    // MARK: task
    
    var task: Task {
        switch self {
        case let .getImages(query, page, numberOfImagesToLoad):
            return .requestParameters(
                parameters: ["query":query, "page":page, "size":numberOfImagesToLoad],
                encoding: URLEncoding.default
            )
        }
    }
    
    // MARK: path
    
    var path: String {
        switch self {
        case .getImages:
            return "/v2/search/image"
        }
    }
    
//    func dataRequest() -> DataRequest {
//        AF.request(
//            url,
//            method: httpMethod,
//            parameters: prameters,
//            encoding: URLEncoding.default,
//            headers: header
//        )
//        .validate()
//    }
}
