//
//  SearchRepositoryType.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/16.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import RxSwift

protocol SearchRepositoryType {
    func search(keyword: String, page: Int, numberOfImagesToLoad: Int) -> Observable<SearchResponse>
}
