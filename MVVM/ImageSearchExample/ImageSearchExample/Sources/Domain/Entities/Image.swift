//
//  Image.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 03/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation
import RxDataSources

struct Image: Codable {
    let thumbnailURL: String
    let imageURL: String
    let width: Int
    let height: Int
    let displaySitename: String
    let docURL: String
    let datetime: String

    private enum CodingKeys: String, CodingKey {
        case thumbnailURL = "thumbnail_url"
        case imageURL = "image_url"
        case width
        case height
        case displaySitename = "display_sitename"
        case docURL = "doc_url"
        case datetime
    }
}
