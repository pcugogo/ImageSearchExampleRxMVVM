//
//  Coordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

typealias Coordinator = BaseCoordinator & Coordinatable
typealias Router = BaseCoordinator & Routable

protocol Dependency {}

protocol Coordinatable {
    associatedtype DependencyType: Dependency
    func start(with dependency: DependencyType)
}

protocol Routable {
    associatedtype Route
    func navigate(to route: Route)
}

class BaseCoordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
