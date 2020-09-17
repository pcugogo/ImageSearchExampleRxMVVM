//
//  AppBuilder.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class AppBuilder: ViewControllerBuilder {
    enum Target {
        case search
    }
    
    init(target: Target, dependency: Container = Container()) {
        super.init(dependency: dependency)
        switch target {
        case .search:
            dependency.regist(type: APIServiceType.self) { _ in APIService() }
            dependency.regist(type: SearchUseCaseType.self) {
                SearchUseCase(apiService: $0.resolve(type: APIServiceType.self)!)
            }
            dependency.regist(type: SearchViewModelType.self) {
                SearchViewModel(searchUseCase: $0.resolve(type: SearchUseCaseType.self)!)
            }
            dependency.regist(type: UIViewController.self) {
                let storyboard = StoryboardName.main.instantiateStoryboard()
                guard let navigationController = storyboard.instantiateViewController(withIdentifier: "SearchNavigationController") as? UINavigationController else {
                    fatalError()
                }
                guard var searchViewController = navigationController.viewControllers.first as? SearchViewController else {
                    fatalError()
                }
                let viewModel: SearchViewModelType = $0.resolve(type: SearchViewModelType.self)!
                searchViewController.bind(viewModel: viewModel)
                return navigationController
            }
        }
        self.dependency = dependency
    }
}
