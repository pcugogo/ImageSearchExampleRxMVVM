//
//  SearchCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit
import SCoordinator

final class SearchCoordinator: Coordinator<UINavigationController> {
    
    func start(with dependency: SearchViewModel.Dependency) {}
    
    func navigate(to route: Route) {
        guard let searchRoute = route as? SearchRoute else { return }
        switch searchRoute {
        case .detailImage(let imageURLString):
            navigateToDetailImage(urlString: imageURLString)
        }
    }
}

extension SearchCoordinator {
    
    func navigateToDetailImage(urlString: String) {
        let dependency = DetailImageViewModel.Dependency(
            imageURLString: urlString,
            imageFavoritesStorage: ImageFavoritesStorage()
        )
        let viewModel = DetailImageViewModel(coordinator: self, dependency: dependency)
        var detailImageViewController = DetailImageViewController.instantiateFromStoryboard()
        detailImageViewController.bind(viewModel: viewModel)
        root?.pushViewController(detailImageViewController, animated: true)
    }
}
