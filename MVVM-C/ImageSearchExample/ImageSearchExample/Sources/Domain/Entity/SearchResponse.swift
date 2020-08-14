//
//  SearchResult.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 03/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
    let images: [ImageData]
    let meta: Meta
    
    private enum CodingKeys: String, CodingKey {
        case images = "documents"
        case meta
    }
}
