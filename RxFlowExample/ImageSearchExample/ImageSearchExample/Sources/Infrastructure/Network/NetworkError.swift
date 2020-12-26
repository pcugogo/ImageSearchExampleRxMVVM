//
//  NetworkError.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/11/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

enum NetworkError: Int, Error {
    case unknown = 0
    case badRequest = 400
    case unauthorized = 401
    case notFound = 404
    case serverError = 500
    case notConnected = -1009
    case timeOut = -1001
}

extension NetworkError {
    
    var message: String {
        switch self {
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        case .badRequest:
            return "잘못된 요청입니다."
        case .unauthorized:
            return "인증에 실패 하였습니다. (API Key가 없습니다.)"
        case .notFound:
            return "찾을 수 없는 정보입니다."
        case .serverError:
            return "서버에 접속할 수 없습니다.\n잠시 후에 다시 이용해주세요."
        case .notConnected:
            return "인터넷 연결이 원활하지 않습니다.\n인터넷 연결 확인 후 다시 시도해 주세요."
        case .timeOut:
            return "요청 시간이 초과 되었습니다."
        }
    }
}
