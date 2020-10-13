//
//  Coordinator.swift
//  ImageSearchExample
//
//  Created by ChanWook Park on 15/08/2020.
//  Copyright © 2020 ChanWookPark. All rights reserved.
//

import UIKit

typealias Coordinator = BaseCoordinator & Coordinatable & CoordinatorType

protocol CoordinatorType: class {
    func navigate(to route: Route)
}

protocol Coordinatable: class {
    associatedtype Dependency
    func start(with dependency: Dependency)
}

class BaseCoordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}
