//
//  SearchCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class SearchCoordinator: Coordinator & CoordinatorPresentable {
    
    struct Dependency {
        let searchUseCase: SearchUseCaseType
        
        init(searchUseCase: SearchUseCaseType) {
            self.searchUseCase = searchUseCase
        }
    }
    
    enum Target {
        case detailImage(imageURLString: String)
    }
    
    //Coordinate
    func start(with dependency: Dependency) {
        var searchViewController = navigationController?.viewControllers.first as! SearchViewController
        let viewModel: SearchViewModelType = SearchViewModel(coordinator: self, dependency: dependency)
        searchViewController.bind(viewModel: viewModel)
    }

    //View Transition
    func present(to target: Target) {
        switch target {
        case .detailImage(let imageURLString):
            let coordinator = DetailImageCoordinator(navigationController: navigationController!)
            let dependency = DetailImageCoordinator.Dependency(imageURLString: imageURLString,
                                                               imageFavoritesStorage: ImageFavoritesStorage())
            coordinator.start(with: dependency)
        }
    }
}
