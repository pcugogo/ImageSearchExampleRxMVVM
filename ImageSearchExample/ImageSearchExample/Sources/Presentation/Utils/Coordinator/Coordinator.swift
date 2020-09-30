//
//  Coordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

typealias Coordinator = BaseCoordinator & CoordinatorPresentable

protocol CoordinatorPresentable {
    associatedtype Dependency
    associatedtype Route
    func present(for route: Route)
}

class BaseCoordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
