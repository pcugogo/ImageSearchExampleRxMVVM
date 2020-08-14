//
//  SearchMaker.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 14/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

struct SearchMaker: ViewControllerMaker {
    let searchUseCase: SearchUseCaseType

    init(searchUseCase: SearchUseCaseType) {
        self.searchUseCase = searchUseCase
    }
    
    func makeViewController() -> UIViewController {
        let storyboard = StoryboardName.main.instantiateStoryboard()
        guard let navigationController = storyboard.instantiateViewController(withIdentifier: "SearchNavigationController") as? UINavigationController else {
            fatalError()
        }
        guard var searchViewController = navigationController.viewControllers.first as? SearchViewController else {
            fatalError()
        }
        let viewModel: SearchViewModelType = SearchViewModel(searchUseCase: searchUseCase)
        searchViewController.bind(viewModel: viewModel)
        return navigationController
    }
}
