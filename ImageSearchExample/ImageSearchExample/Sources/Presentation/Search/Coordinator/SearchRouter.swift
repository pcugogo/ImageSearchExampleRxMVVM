//
//  SearchRouter.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/10/03.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import Foundation

final class SearchRouter: Router {
    
    enum Route {
        case detailImage(imageURLString: String)
    }
    
    func navigate(to route: Route) {
        switch route {
        case .detailImage(let imageURLString):
            let coordinator = DetailImageCoordinator(navigationController: navigationController!)
            let dependency = DetailImageDependency(imageURLString: imageURLString,
                                                           imageFavoritesStorage: ImageFavoritesStorage())
            coordinator.start(with: dependency)
        }
    }
}
