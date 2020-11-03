//
//  DetailImageCoordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 2020/09/30.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

final class DetailImageCoordinator: Coordinator {
    
    func start(with dependency: DetailImageViewModel.Dependency) {
        let viewModel = DetailImageViewModel(coordinator: self, dependency: dependency)
        let storyboard = StoryboardName.main.instantiateStoryboard()
        var detailImageViewController = storyboard.instantiateViewController(withIdentifier:
            String(describing: DetailImageViewController.self)) as! DetailImageViewController
        detailImageViewController.bind(viewModel: viewModel)
        navigationController?.pushViewController(detailImageViewController, animated: true)
    }
    
    func navigate(to route: Route) {}
}
