//
//  SearchCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

struct SearchDependency: Dependency {
    let searchUseCase: SearchUseCaseType
    
    init(searchUseCase: SearchUseCaseType) {
        self.searchUseCase = searchUseCase
    }
}

final class SearchCoordinator: Coordinator {
    
    func start(with dependency: SearchDependency) {
        var searchViewController = navigationController?.viewControllers.first as! SearchViewController
        let viewModel: SearchViewModelType = SearchViewModel(router: SearchRouter(navigationController: navigationController!),
                                                             dependency: dependency)
        searchViewController.bind(viewModel: viewModel)
    }
}
