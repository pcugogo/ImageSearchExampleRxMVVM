//
//  Meta.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 03/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

struct Meta: Decodable {
    let totalCount: Int
    let pageableCount: Int
    var isEnd: Bool
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}
