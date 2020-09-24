//
//  SearchBuilder.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

struct SearchBuilder: ViewControllerBuilder {
    func build(_ dependency: Container = .init()) -> Container {
        dependency.regist(type: APIServiceType.self) { _ in APIService() }
        dependency.regist(type: SearchUseCaseType.self) {
            SearchUseCase(apiService: $0.resolve(type: APIServiceType.self)!)
        }
        dependency.regist(type: SearchViewModelType.self) {
            SearchViewModel(searchUseCase: $0.resolve(type: SearchUseCaseType.self)!)
        }
        dependency.regist(type: UIViewController.self) {
            let storyboard = StoryboardName.main.instantiateStoryboard()
            let navigationController = storyboard.instantiateViewController(withIdentifier: "SearchNavigationController") as! UINavigationController
            var searchViewController = navigationController.viewControllers.first as! SearchViewController
            let viewModel: SearchViewModelType = $0.resolve(type: SearchViewModelType.self)!
            searchViewController.bind(viewModel: viewModel)
            return navigationController
        }
        return dependency
    }
}
