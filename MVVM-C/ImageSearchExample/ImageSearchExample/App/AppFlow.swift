//
//  AppFlow.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class AppFlow: ViewControllerFlow {
    enum Target {
        case search(useCase: SearchUseCaseType)
    }
    
    var target: Target

    var viewController: UIViewController {
        switch target {
        case .search(let useCase):
            return makeSearchViewController(useCase: useCase)
        }
    }

    init(target: Target) {
        self.target = target
    }
    
    private func makeSearchViewController(useCase: SearchUseCaseType) -> UIViewController {
        let storyboard = StoryboardName.main.instantiateStoryboard()
        guard let navigationController = storyboard.instantiateViewController(withIdentifier: "SearchNavigationController") as? UINavigationController else {
            fatalError()
        }
        guard var searchViewController = navigationController.viewControllers.first as? SearchViewController else {
            fatalError()
        }
        let viewModel: SearchViewModelType = SearchViewModel(searchUseCase: useCase)
        searchViewController.bind(viewModel: viewModel)
        return navigationController
    }
}
