//
//  SearchCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class SearchCoordinator: Coordinator {
    
    func start(with dependency: SearchViewModel.Dependency) {
        var searchViewController = navigationController?.viewControllers.first as! SearchViewController
        let viewModel = SearchViewModel(coordinator: self, dependency: dependency)
        searchViewController.bind(viewModel: viewModel)
    }
    
    func navigate(to route: Route) {
        switch route {
        case .detailImage(let imageURLString):
            let coordinator = DetailImageCoordinator(navigationController: navigationController!)
            let dependency = DetailImageViewModel.Dependency(
                imageURLString: imageURLString,
                imageFavoritesStorage: ImageFavoritesStorage()
            )
            coordinator.start(with: dependency)
        }
    }
}
