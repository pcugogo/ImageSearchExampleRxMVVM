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
        var detailImageViewController = DetailImageViewController.instantiateFromStoryboard()
        detailImageViewController.bind(viewModel: viewModel)
        presenter.present(targetViewController: detailImageViewController)
    }
    
    func navigate(to route: Route) {}
}
