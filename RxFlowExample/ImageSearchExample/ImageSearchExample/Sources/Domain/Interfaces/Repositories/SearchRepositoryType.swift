//
//  SearchRepositoryType.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2021/01/18.
//  Copyright © 2021 ChanWookPark. All rights reserved.
//

import RxSwift

protocol SearchRepositoryType {
    func search(keyword: String, page: Int, numberOfImagesToLoad: Int) -> Observable<SearchResponse>
}
