//
//  SearchCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class SearchCoordinator: Coordinator {
    
    struct Dependency {
        let searchUseCase: SearchUseCaseType
        
        init(searchUseCase: SearchUseCaseType) {
            self.searchUseCase = searchUseCase
        }
    }
    
    enum Route {
        case detailImage(imageURLString: String)
    }
    
    func present(for route: Route) {
        switch route {
        case .detailImage(let imageURLString):
            let coordinator = DetailImageCoordinator(navigationController: navigationController!)
            let dependency = DetailImageCoordinator.Dependency(imageURLString: imageURLString,
                                                               imageFavoritesStorage: ImageFavoritesStorage())
            let viewModel = DetailImageViewModel(coordinator: coordinator, dependency: dependency)
            let storyboard = Storyboard.main.instantiate()
            var detailImageViewController = storyboard.instantiateViewController(type: DetailImageViewController.self)!
            detailImageViewController.bind(viewModel: viewModel)
            navigationController?.pushViewController(detailImageViewController, animated: true)
        }
    }
}
