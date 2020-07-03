//
//  SearchResult.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 03/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
    let documents: [Image]
    let meta: Meta
}
