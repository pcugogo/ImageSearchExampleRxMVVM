//
//  SearchImageDummy.swift
//  ImageSearchExampleTests
//
//  Created by ChanWook Park on 02/05/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

@testable import ImageSearchExample

protocol DummyDataType {
    var jsonString: String { get }
}

struct SearchImageDummy: DummyDataType {
    let jsonString = """
    {
      "meta": {
        "total_count": 422583,
        "pageable_count": 3854,
        "is_end": false
      },
      "documents": [
        {
          "collection": "news",
          "thumbnail_url": "https://search2.kakaocdn.net/argon/130x130_85_c/36hQpoTrVZp",
          "image_url": "http://t1.daumcdn.net/news/201706/21/kedtv/20170621155930292vyyx.jpg",
          "width": 540,
          "height": 457,
          "display_sitename": "한국경제TV",
          "doc_url": "http://v.media.daum.net/v/20170621155930002",
          "datetime": "2017-06-21T15:59:30.000+09:00"
        },
        {
          "collection": "news",
          "thumbnail_url": "https://search2.kakaocdn.net/argon/130x130_85_c/36hQpoTrVZp",
          "image_url": "http://t1.daumcdn.net/news/201706/21/kedtv/20170621155930292vyyx.jpg",
          "width": 540,
          "height": 457,
          "display_sitename": "한국경제TV",
          "doc_url": "http://v.media.daum.net/v/20170621155930002",
          "datetime": "2017-06-21T15:59:30.000+09:00"
        }
      ]
    }
"""
    let imageURLString = "http://t1.daumcdn.net/news/201706/21/kedtv/20170621155930292vyyx.jpg"
    var count: Int {
        let data = jsonString.data(using: .utf8)!
        guard let imageSearchResponse = try? JSONDecoder().decode(SearchResponse.self, from: data) else { return 0 }
        return imageSearchResponse.meta.totalCount
    }
}
