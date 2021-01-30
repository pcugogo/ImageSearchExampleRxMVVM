//
//  AppCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit
import SCoordinator

final class AppCoordinator: RootCoordinator<UIWindow> {
    
    override func navigate(to route: Route) {
        guard let appRoute = route as? AppRoute else { return }
        switch appRoute {
        case .search:
            rootView.rootViewController = navigateToSearch()
        }
        rootView.makeKeyAndVisible()
    }
}

extension AppCoordinator {
    
    private func navigateToSearch() -> UINavigationController {
        
        let storyboard = StoryboardName.main.instantiateStoryboard()
        let navigationController = storyboard
            .instantiateViewController(withIdentifier: "SearchNavigationController") as! UINavigationController
        let searchCoordinator = SearchCoordinator(rootView: navigationController)
        searchCoordinator.start(with: self)
        var searchViewController = navigationController.viewControllers.first as! SearchViewController
        let viewModel = SearchViewModel(coordinator: searchCoordinator, searchUseCase: SearchUseCase())
        searchViewController.bind(viewModel: viewModel)
        return navigationController
    }
}
