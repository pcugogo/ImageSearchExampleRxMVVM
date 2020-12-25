//
//  SearchRoute.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/13.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import SCoordinator

enum AppRoute: Route {
    case search
}
enum SearchRoute: Route {
    case detailImage(imageURLString: String)
}
