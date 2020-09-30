//
//  AppCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class AppCoordinator {
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let storyboard = Storyboard.main.instantiate()
        let navigationController = storyboard.instantiateViewController(withIdentifier: "SearchNavigationController") as! UINavigationController
        var searchViewController = navigationController.viewControllers.first as! SearchViewController
        let searchCoordinator = SearchCoordinator(navigationController: navigationController)
        let dependency = SearchCoordinator.Dependency(searchUseCase: SearchUseCase(apiService: APIService()))
        let viewModel: SearchViewModelType = SearchViewModel(coordinator: searchCoordinator, dependency: dependency)
        searchViewController.bind(viewModel: viewModel)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
