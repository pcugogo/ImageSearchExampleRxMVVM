//
//  ImageSearchFlow.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/12/09.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit
import RxFlow

final class ImageSearchFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    var rootViewController: UINavigationController = {
        let storyboard = StoryboardName.main.instantiateStoryboard()
        let navigationController = storyboard
            .instantiateViewController(withIdentifier: "SearchNavigationController") as! UINavigationController
        return navigationController
    }()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ImageSearchStep else { return .none }
        switch step {
        case .search:
            return navigateToSearch()
        case .detailImage(let imageURLString):
            return navigateToDetail(imageURLString)
        }
    }
}

extension ImageSearchFlow {
    
    private func navigateToSearch() -> FlowContributors {
        var searchViewController = SearchViewController.instantiateFromStoryboard()
        let dependency = SearchViewModel.Dependency(searchUseCase: SearchUseCase())
        let viewModel = SearchViewModel(dependency: dependency)
        searchViewController.bind(viewModel: viewModel)
        rootViewController.viewControllers = [searchViewController]
        let contribute: FlowContributor = .contribute(
            withNextPresentable: searchViewController,
            withNextStepper: viewModel
        )
        return .one(flowContributor: contribute)
    }
    
    private func navigateToDetail(_ imageURLString: String) -> FlowContributors {
        let dependency = DetailImageViewModel.Dependency(
            imageURLString: imageURLString,
            fetchFavoritesUseCase: FetchFavoritesUseCase()
        )
        let viewModel = DetailImageViewModel(dependency: dependency)
        var detailImageViewController = DetailImageViewController.instantiateFromStoryboard()
        detailImageViewController.bind(viewModel: viewModel)
        rootViewController.pushViewController(detailImageViewController, animated: true)
        let contribute: FlowContributor = .contribute(
            withNextPresentable: detailImageViewController,
            withNextStepper: viewModel
        )
        return .one(flowContributor: contribute)
    }
}
